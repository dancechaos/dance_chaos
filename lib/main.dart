// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/localization.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:dance_chaos/presentation/home_screen.dart';
import 'package:dance_chaos/presentation/user/profile_page.dart';
import 'package:dance_chaos/presentation/user/register_or_signin_page.dart';
import 'package:dance_chaos/reducers/app_state_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'app/core/localization.dart';
import 'app/core/routes.dart';
import 'app/core/theme.dart';
import 'app/repo/profile_repository.dart';
import 'app/repo/reactive_repository.dart';
import 'app/repo/user_repository.dart';
import 'containers/map/map_screen.dart';
import 'containers/todo/add_todo.dart';
import 'firebase/middleware/store_todos_middleware.dart';
import 'firebase/repo/reactive_todos_repository.dart';
import 'firebase/repo/firestore_profile_repository.dart';
import 'firebase/repo/user_repository.dart';

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
    bool useLocalFirebaseEmulator = false,
  })  : store = Store<AppState>(
          appReducer,
          initialState: AppState.loading(),
          middleware: createStoreTodosMiddleware(
            todosRepository ?? FirestoreReactiveTodosRepository(),
            userRepository ?? FirebaseUserRepository(),
            profileRepository ?? FirestoreProfileRepository(useLocalFirebaseEmulator: useLocalFirebaseEmulator),
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
          ArchSampleRoutes.maps: (context) => FireMap(profile: store.state.profile),
        },
      ),
    );
  }
}
