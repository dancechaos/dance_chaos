// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/app/repo/profile_entity.dart';
import 'package:dance_chaos/app/repo/profile_repository.dart';
import 'package:dance_chaos/app/repo/reactive_repository.dart';
import 'package:dance_chaos/app/repo/todo_entity.dart';
import 'package:dance_chaos/app/repo/user_repository.dart';
import 'package:dance_chaos/app/repo/utility.dart';
import 'package:dance_chaos/models/location_info.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:dance_chaos/selectors/selectors.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  ReactiveTodosRepository todosRepository,
  UserRepository userRepository,
  ProfileRepository profileRepository,
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
      _changeLocation(userRepository),
    ),
    TypedMiddleware<AppState, ProfileChangedAction>(
      _profileChanged(userRepository, profileRepository),
    ),
    TypedMiddleware<AppState, ConnectToDataSourceAction>(
      _connectToDataSource(todosRepository),
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

void Function(
    Store<AppState> store,
    ChangeLocationAction action,
    NextDispatcher next,
    ) _changeLocation (
    UserRepository repository,
    ) {
  return (store, action, next) {
    LocationInfo initialLocation = store.state.locationInfo;
    next(action);

    if (initialLocation != store.state.locationInfo) {  // User location changed, now update my location in the shared repo
      print('------------------changeLocation profile: ${action
          .profile}, location (lat,long): (${action.location
          ?.latitude}, ${action.location
          ?.longitude}) '); // todo(don) UpdateLocation
    }
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
    ) {
  return (store, action, next) {
    next(action);

    todosStreamSubscription?.cancel();
    if (store.state.profile != null && store.state.profile != Profile.noProfile) {
      todosStreamSubscription = repository.todos(store.state.profile.id).listen((todos) {
        store.dispatch(LoadTodosAction(todos.map(Todo.fromEntity).toList()));
      });
    } else {
      store.dispatch(LoadTodosAction(List<Todo>()));  // Empty list for anonymous user
    }
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
          store.dispatch(ChangeLocationAction(store.state.profile, geoPoint));  // Device move event
        });
        store.dispatch(ChangeLocationAction(store.state.profile, geoPoint));  // Set initial location
      });
      break;
    case TrackingState.trackingOff:
      locationStreamSubscription?.cancel(); // Stop listening for tracking changes
      locationStreamSubscription = null;
      store.dispatch(ChangeLocationAction(store.state.profile, null));
      break;
  }
}

StreamSubscription<List<TodoEntity>> todosStreamSubscription;

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
