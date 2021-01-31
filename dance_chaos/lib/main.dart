// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos/localization.dart';
import 'package:dance_chaos_data/app/core/localization.dart';
import 'package:dance_chaos_data/app/core/routes.dart';
import 'package:dance_chaos_data/app/core/theme.dart';
import 'package:dance_chaos_data/app/repo/dance_profile_repository.dart';
import 'package:dance_chaos_data/app/repo/location_repository.dart';
import 'package:dance_chaos_data/app/repo/profile_repository.dart';
import 'package:dance_chaos_data/app/repo/reactive_repository.dart';
import 'package:dance_chaos_data/app/repo/user_repository.dart';
import 'package:dance_chaos_data/firebase/middleware/store_todos_middleware.dart';
import 'package:dance_chaos_data/firebase/repo/firestore_dance_profile_repository.dart';
import 'package:dance_chaos_data/firebase/repo/firestore_location_repository.dart';
import 'package:dance_chaos_data/firebase/repo/firestore_profile_repository.dart';
import 'package:dance_chaos_data/firebase/repo/reactive_todos_repository.dart';
import 'package:dance_chaos_data/firebase/repo/user_repository.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:dance_chaos/presentation/home_screen.dart';
import 'package:dance_chaos/presentation/user/profile_page.dart';
import 'package:dance_chaos/presentation/user/register_or_signin_page.dart';
import 'package:dance_chaos/reducers/app_state_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'containers/todo/add_todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(DanceChaosApp());
}

class DanceChaosApp extends StatelessWidget {
  final Store<AppState> store;

  DanceChaosApp({
    Key key,
    ReactiveTodosRepository todosRepository,
    UserRepository userRepository,
    ProfileRepository profileRepository,
    DanceProfileRepository danceProfileRepository,
    LocationRepository locationRepository,
    bool useLocalFirebaseEmulator = false,
  })  : store = Store<AppState>(
          appReducer,
          initialState: AppState.loading(),
          middleware: createStoreTodosMiddleware(
            todosRepository ?? FirestoreReactiveTodosRepository(),
            userRepository ?? FirestoreUserRepository(),
            profileRepository ?? FirestoreProfileRepository(useLocalFirebaseEmulator: useLocalFirebaseEmulator),
            danceProfileRepository ?? FirestoreDanceProfileRepository(),
            locationRepository ?? FirestoreLocationRepository(),
          ),
        ),
        super(key: key) {
    store.dispatch(InitAppAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        onGenerateTitle: (context) =>
            FirestoreReduxLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          FirestoreReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddTodo(),
          ArchSampleRoutes.profile: (context) => ProfilePage(profile: store.state.profile),
          ArchSampleRoutes.register: (context) => RegisterOrSignInPage(authScreen: AuthScreenType.register),
          ArchSampleRoutes.signIn: (context) => RegisterOrSignInPage(authScreen: AuthScreenType.signIn,),
//          ArchSampleRoutes.danceProfile: (context) => DanceProfileList(danceProfiles: store.state.profile.danceProfileList),
//          ArchSampleRoutes.maps: (context) => FireMap(profile: store.state.profile),
        },
      ),
    );
  }
}
