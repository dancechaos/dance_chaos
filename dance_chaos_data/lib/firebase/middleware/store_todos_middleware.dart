import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos_data/app/entity/location_info_entity.dart';
import 'package:dance_chaos_data/app/entity/profile_entity.dart';
import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:dance_chaos_data/app/repo/dance_profile_repository.dart';
import 'package:dance_chaos_data/app/repo/location_repository.dart';
import 'package:dance_chaos_data/app/repo/profile_repository.dart';
import 'package:dance_chaos_data/app/repo/reactive_repository.dart';
import 'package:dance_chaos_data/app/repo/user_repository.dart';
import 'package:dance_chaos_data/models/dance_profile.dart';
import 'package:dance_chaos_data/models/location_info.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos_data/models/profile.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:dance_chaos_data/selectors/selectors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  ReactiveTodosRepository todosRepository,
  UserRepository userRepository,
  ProfileRepository profileRepository,
  DanceProfileRepository danceProfileRepository,
  LocationRepository locationRepository,
) {
  return [
    TypedMiddleware<AppState, InitAppAction>(
      _initApp(userRepository),
    ),
    TypedMiddleware<AppState, UserChangedAction>(
      _userChanged(userRepository),
    ),
    TypedMiddleware<AppState, SignInAction>(
      _signIn(userRepository),
    ),
    TypedMiddleware<AppState, SyncProfileToUserAction>(
      _syncProfileToUser(userRepository, profileRepository),
    ),
    TypedMiddleware<AppState, ChangeLocationAction>(
      _changeLocation(locationRepository),
    ),
    TypedMiddleware<AppState, ListenForMapChangesAction>(
      _listenForMapChanges(locationRepository),
    ),
    TypedMiddleware<AppState, SetRadiusAction>(
      _setRadiusAction(locationRepository),
    ),
    TypedMiddleware<AppState, ProfileChangedAction>(
      _profileChanged(userRepository, profileRepository),
    ),
    TypedMiddleware<AppState, ConnectToDataSourceAction>(
      _connectToDataSource(todosRepository, danceProfileRepository),
    ),
    TypedMiddleware<AppState, AddNewTodoAction>(
      _addNewTodo(todosRepository),
    ),
    TypedMiddleware<AppState, DeleteTodoAction>(
      _deleteTodo(todosRepository),
    ),
    TypedMiddleware<AppState, UpdateTodoAction>(
      _updateTodo(todosRepository),
    ),
    TypedMiddleware<AppState, ExecuteProfileAction>(
      _executeProfileAction(userRepository, profileRepository),
    ),
    TypedMiddleware<AppState, UpdateProfileAction>(
      _updateProfile(profileRepository),
    ),
    TypedMiddleware<AppState, AddDanceProfileAction>(
      _addDanceProfile(danceProfileRepository),
    ),
    TypedMiddleware<AppState, UpdateDanceProfileAction>(
      _updateDanceProfile(danceProfileRepository),
    ),
    TypedMiddleware<AppState, DeleteDanceProfileAction>(
      _deleteDanceProfile(danceProfileRepository),
    ),
    TypedMiddleware<AppState, UpdateDancesAction>(
      _updateDances(danceProfileRepository),
    ),
    TypedMiddleware<AppState, ToggleAllAction>(
      _toggleAll(todosRepository),
    ),
    TypedMiddleware<AppState, ClearCompletedAction>(
      _clearCompleted(todosRepository),
    ),
  ];
}

void Function(
    Store<AppState> store,
    InitAppAction action,
    NextDispatcher next,
    ) _initApp (
    UserRepository repository,
    ) {
  return (store, action, next) {
    next(action);

    repository.initApp().then((_) {
      repository.userChanges().listen((userEntity) {
        store.dispatch(UserChangedAction(userEntity));
      });
    });
  };
}

void Function(
    Store<AppState> store,
    UserChangedAction action,
    NextDispatcher next,
    ) _userChanged (
    UserRepository repository,
    ) {
  return (store, action, next) {
    next(action);

    if (action.userEntity == null) {
        store.dispatch(SignInAction()); // Anonymous login
    } else if (action.userEntity.isAnonymous) {
      store.dispatch(SyncProfileToUserAction(action.userEntity));
    } else {
      store.dispatch(SyncProfileToUserAction(action.userEntity));
    }
  };
}

void Function(
    Store<AppState> store,
    SignInAction action,
    NextDispatcher next,
    ) _signIn (
    UserRepository repository,
    ) {
  return (store, action, next) {
    next(action);

    repository.signIn(user: action.email, password: action.password)
        .then((value) {
      store.dispatch(UpdateUserSignInStatusAction(email: action.email, passwordHash: action.password?.hashCode ,userSignInStatus: UserSignInStatus.signedIn));
    })
        .catchError((error) {
      store.dispatch(UpdateUserSignInStatusAction(email: action.email, passwordHash: action.password?.hashCode ,userSignInStatus: UserSignInStatus.error, error: error));
    });
  };
}

Timestamp lastTimerTimestamp;
Timer locationTimer;

const int REFRESH_TIME_IN_SECONDS = 10 * 60;  // 10 Minutes
const timerDuration = const Duration(seconds: REFRESH_TIME_IN_SECONDS);

Timer _resetTimer(LocationRepository locationRepository) {
  locationTimer?.cancel();
  lastTimerTimestamp = Timestamp.now();
  return locationTimer = new Timer(timerDuration, () {
    _changeLocation(locationRepository);
  });
}

void Function(
    Store<AppState> store,
    ChangeLocationAction action,
    NextDispatcher next,
    ) _changeLocation (
    LocationRepository locationRepository,
    ) {
  return (store, action, next) {
    LocationInfo initialLocation = store.state.locationInfo;
    next(action);

    if (initialLocation != store.state.locationInfo || store.state.locationInfo.timestamp.seconds > lastTimerTimestamp.seconds + REFRESH_TIME_IN_SECONDS) {  // User location changed, now update my location in the shared repo
      print('changeLocation profile: ${action.profile}, location (lat,long): (${action.location?.latitude}, ${action.location?.longitude}) ');
      locationRepository.updateLocation(store.state.locationInfo?.toEntity());
      _resetTimer(locationRepository);  // Update this again if location has not changed in 15 minutes.
    }
  };
}

StreamSubscription<List<LocationInfoEntity>> _locationInfoChangedStreamSubscription;

void Function(
    Store<AppState> store,
    ListenForMapChangesAction action,
    NextDispatcher next,
    ) _listenForMapChanges (
    LocationRepository locationRepository,
    ) {
  return (store, action, next) {
    next(action);

    _locationInfoChangedStreamSubscription?.cancel();
    _locationInfoChangedStreamSubscription = null;
    // Listen for changes to this profile
    if (store.state.locationInfo != null) {
      LatLng location = LatLng(store.state.locationInfo.location.latitude, store.state.locationInfo.location.longitude);
      _locationInfoChangedStreamSubscription =
          locationRepository.locationChanges(location).listen((listLocationInfoEntity) {
            action.onMapChange(listLocationInfoEntity);
          });
    }
  };
}

void Function(
    Store<AppState> store,
    SetRadiusAction action,
    NextDispatcher next,
    ) _setRadiusAction (
    LocationRepository locationRepository,
    ) {
  return (store, action, next) {
    next(action);

    locationRepository.setRadius(action.radiusKm);
  };
}

StreamSubscription<ProfileEntity> _profileChangedStreamSubscription;

void Function(
    Store<AppState> store,
    SyncProfileToUserAction action,
    NextDispatcher next,
    ) _syncProfileToUser (
      UserRepository userRepository,
      ProfileRepository profileRepository,
    ) {
  return (store, action, next) {
    next(action);

    _profileChangedStreamSubscription?.cancel();
    _profileChangedStreamSubscription = null;
    if (action.userEntity.id == Profile.noProfile.id || action.userEntity.isAnonymous) {
      ProfileEntity profileEntity = Profile.noProfile.toEntity();
      store.dispatch(ProfileChangedAction(Profile.fromEntity(profileEntity, userSignInStatus: UserSignInStatus.signedIn)));
      return profileEntity;
    }

    // Listen for changes to this profile
    _profileChangedStreamSubscription = profileRepository.profileChanges(action.userEntity.id).listen((profileEntity) {
      store.dispatch(ProfileChangedAction(Profile.fromEntity(profileEntity, userSignInStatus: UserSignInStatus.signedIn)));
    });

    return profileRepository.getProfile(action.userEntity); // This will trigger the first change
  };
}

void Function(
    Store<AppState> store,
    ProfileChangedAction action,
    NextDispatcher next,
    ) _profileChanged (
    UserRepository userRepository,
    ProfileRepository profileRepository,
    ) {
  return (store, action, next) {
    TrackingState trackingBefore = store.state.profile?.tracking;
    next(action);   // Have reducer change state
    if (store.state.profile?.tracking != trackingBefore) {
      _updateLocationTracking(store, userRepository);
    }

    store.dispatch(ConnectToDataSourceAction());  // Read profile todos
  };
}

void Function(
    Store<AppState> store,
    ConnectToDataSourceAction action,
    NextDispatcher next,
    ) _connectToDataSource (
    ReactiveTodosRepository repository,
    DanceProfileRepository danceProfileRepository,
    ) {
  return (store, action, next) {
    next(action);

    todosStreamSubscription?.cancel();
    if (store.state.profile != null && store.state.profile != Profile.noProfile) {
      todosStreamSubscription = repository.todos(store.state.profile.id).listen((todos) {
        store.dispatch(LoadTodosAction(todos.map(Todo.fromEntity).toList()));
      });
    } else {
      store.dispatch(LoadTodosAction(List<Todo>.empty()));  // Empty list for anonymous user
    }

    danceProfilesStreamSubscription?.cancel();
    if (store.state.profile != null && store.state.profile != Profile.noProfile) {
      danceProfilesStreamSubscription = danceProfileRepository.danceProfiles(store.state.profile.id).listen((danceProfiles) {
        store.dispatch(LoadDanceProfilesAction(danceProfiles.map(DanceProfile.fromEntity).toList()));
      });
    } else {
      store.dispatch(LoadDanceProfilesAction(List<DanceProfile>.empty()));  // Empty list for anonymous user
    }

  };
}

void Function(
    Store<AppState> store,
    AddDanceProfileAction action,
    NextDispatcher next,
    ) _addDanceProfile (
    DanceProfileRepository danceProfileRepository,
    ) {
  return (store, action, next) {
    next(action);

    danceProfileRepository.addNewDanceProfile(action.profileId, action.updatedDanceProfile.toEntity());
  };
}

void Function(
    Store<AppState> store,
    UpdateDanceProfileAction action,
    NextDispatcher next,
    ) _updateDanceProfile (
    DanceProfileRepository danceProfileRepository,
    ) {
  return (store, action, next) {
    next(action);

    danceProfileRepository.updateDanceProfile(action.profileId, action.updatedDanceProfile.toEntity());
  };
}

void Function(
    Store<AppState> store,
    DeleteDanceProfileAction action,
    NextDispatcher next,
    ) _deleteDanceProfile (
    DanceProfileRepository danceProfileRepository,
    ) {
  return (store, action, next) {
    next(action);

    danceProfileRepository.deleteDanceProfile(action.profileId, action.idList);
  };
}

void Function(
    Store<AppState> store,
    UpdateDancesAction action,
    NextDispatcher next,
    ) _updateDances (
    DanceProfileRepository danceProfileRepository,
    ) {
  return (store, action, next) {
    next(action);

    danceProfileRepository.getDances(action.languageCode, action.countryCode, action.onDancesUpdated);
  };
}

void Function(
    Store<AppState> store,
    UpdateProfileAction action,
    NextDispatcher next,
    ) _updateProfile (
    ProfileRepository profileRepository,
    ) {
  return (store, action, next) {
    next(action);

    profileRepository.updateProfile(action.updatedProfile.toEntity());
  };
}

void Function(
    Store<AppState> store,
    ExecuteProfileAction action,
    NextDispatcher next,
    ) _executeProfileAction (
    UserRepository userRepository,
    ProfileRepository profileRepository,
    ) {
  return (store, action, next) {
    next(action);

    switch (action.profileAction) {
      case ProfileAction.trackingWatching:
      case ProfileAction.trackingOn:
      case ProfileAction.trackingOff:
        if (!store.state.profile.isAnonymous)
          profileRepository.updateProfile(store.state.profile.toEntity()); // Note: Tracking was changed in reducer, change in the repo
        _updateLocationTracking(store, userRepository); // Turn device tracking on or off and get location
        break;
      case ProfileAction.signIn:
      case ProfileAction.register:
      case ProfileAction.editProfile:
        print('action: $action.profileAction'); // These were handled in the profile selector
        break;
      case ProfileAction.signOut:
        store.dispatch(SignInAction()); // Anonymous login
        break;
    }
  };
}

StreamSubscription<GeoPoint> locationStreamSubscription;

void _updateLocationTracking(Store<AppState> store, UserRepository userRepository) {
  switch (store.state.profile.tracking) {
    case TrackingState.trackingWatching:
    case TrackingState.trackingOn:
      userRepository.getCurrentLocation().then((geoPoint) { // Get initial position (and init location service)
        locationStreamSubscription?.cancel();
        locationStreamSubscription = userRepository.locationChanges().listen((geoPoint) { // Start listening
          if (store.state.locationInfo.location != geoPoint || store.state.locationInfo.timestamp.seconds < lastTimerTimestamp.seconds + REFRESH_TIME_IN_SECONDS) {
            store.dispatch(ChangeLocationAction(store.state.profile, geoPoint)); // Device move event
          }
        });
        store.dispatch(ChangeLocationAction(store.state.profile, geoPoint));  // Set initial location
      });
      break;
    case TrackingState.trackingOff:
      locationStreamSubscription?.cancel(); // Stop listening for tracking changes
      locationStreamSubscription = null;
      store.dispatch(ChangeLocationAction(store.state.profile, null));
      break;
    default:
      // Ignore
  }
}

StreamSubscription<List<TodoEntity>> todosStreamSubscription;
StreamSubscription<List<DanceProfileEntity>> danceProfilesStreamSubscription;

void Function(
  Store<AppState> store,
  AddNewTodoAction action,
  NextDispatcher next,
) _addNewTodo (
  ReactiveTodosRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.addNewTodo(store.state.profile.id, action.todo.toEntity());
  };
}

void Function(
  Store<AppState> store,
  DeleteTodoAction action,
  NextDispatcher next,
) _deleteTodo (
  ReactiveTodosRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.deleteTodo(store.state.profile.id, [action.id]);
  };
}

void Function(
  Store<AppState> store,
  UpdateTodoAction action,
  NextDispatcher next,
) _updateTodo (
  ReactiveTodosRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.updateTodo(store.state.profile.id, action.updatedTodo.toEntity());
  };
}

void Function(
  Store<AppState> store,
  ToggleAllAction action,
  NextDispatcher next,
) _toggleAll (
  ReactiveTodosRepository repository,
) {
  return (store, action, next) {
    next(action);
    var todos = todosSelector(store.state);

    for (var todo in todos) {
      if (allCompleteSelector(todos)) {
        if (todo.complete) {
          repository.updateTodo(store.state.profile.id, todo.copyWith(complete: false).toEntity());
        }
      } else {
        if (!todo.complete) {
          repository.updateTodo(store.state.profile.id, todo.copyWith(complete: true).toEntity());
        }
      }
    }
  };
}

void Function(
  Store<AppState> store,
  ClearCompletedAction action,
  NextDispatcher next,
) _clearCompleted (
  ReactiveTodosRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.deleteTodo(store.state.profile.id,
      completeTodosSelector(todosSelector(store.state))
          .map((todo) => todo.id)
          .toList(),
    );
  };
}
