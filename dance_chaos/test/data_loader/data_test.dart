// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos_data/app/entity/todo_entity.dart';
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
import 'package:dance_chaos/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import '../test_data.dart';

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

void main() {
  group('Middleware', () {
    test('should log in anonymously start listening for changes', () async {
      final todosRepository = FirestoreReactiveTodosRepository();
      final userRepository = FirestoreUserRepository();
      final profileRepository = FirestoreProfileRepository();
      final danceProfileRepository = FirestoreDanceProfileRepository();
      final locationRepository = FirestoreLocationRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository)
          ..add(captor),
      );

      when(userRepository.initApp()).thenAnswer((_) => SynchronousFuture(null));
      when(userRepository.signIn()).thenAnswer((_) => SynchronousFuture(null));
      when(userRepository.userChanges())
          .thenAnswer((_) => Stream.fromIterable([null]));
      when(profileRepository.profileChanges(any))
          .thenAnswer((_) => Stream.fromIterable([TestData.anonProfileEntity]));

      store.dispatch(InitAppAction());

      await untilCalled(userRepository.userChanges());
      verify(userRepository.userChanges()); // Waiting for user changes

      await untilCalled(userRepository.signIn());
      store.dispatch(UserChangedAction(TestData.anonUserEntity));

      await untilCalled(userRepository.userChanges());

      verify(captor.call(
        any,
        TypeMatcher<ConnectToDataSourceAction>(),
        any,
      ) as dynamic);
    });

    test('should log in valid user', () async {
      final todosRepository = FirestoreReactiveTodosRepository();
      final userRepository = FirestoreUserRepository();
      final profileRepository = FirestoreProfileRepository();
      final danceProfileRepository = FirestoreDanceProfileRepository();
      final locationRepository = FirestoreLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository)
          // ..add(captor), // Note" I do not add the captor because I want the store to change to reflect the new user
      );

      when(userRepository.initApp()).thenAnswer((_) => SynchronousFuture(null));
      when(userRepository.signIn()).thenAnswer((_) => SynchronousFuture(null));
      when(userRepository.userChanges())
          .thenAnswer((_) => Stream.fromIterable([TestData.userEntity]));
      when(profileRepository.profileChanges(any))
          .thenAnswer((_) => Stream.fromIterable([TestData.profileEntity]));
      when(danceProfileRepository.danceProfiles(any))
          .thenAnswer((_) => Stream.fromIterable([[TestData.danceProfileEntity]]));
      when(todosRepository.todos(TestData.profileId))
          .thenAnswer((_) => Stream.fromIterable([[TestData.todoEntity]]));

      store.dispatch(InitAppAction());

      await untilCalled(userRepository.userChanges());
      verify(userRepository.userChanges()); // Waiting for user changes

      await untilCalled(profileRepository.profileChanges(TestData.profileId));
      verify(profileRepository.profileChanges(TestData.profileId)); // Waiting for user changes

      await untilCalled(todosRepository.todos(TestData.profileId));
      verify(todosRepository.todos(TestData.profileId));

      expect(store.state.todos.length, 1);
      expect(store.state.todos[0].toEntity(), TestData.todoEntity);
    });

    test('should clear the completed todos from the repository', () {
      final todoA = Todo(note: 'A');
      final todoB = Todo(note: 'B', complete: true);
      final todoC = Todo(note: 'C', complete: true);
      final todosRepository = FirestoreReactiveTodosRepository();
      final userRepository = FirestoreUserRepository();
      final profileRepository = FirestoreProfileRepository();
      final danceProfileRepository = FirestoreDanceProfileRepository();
      final locationRepository = FirestoreLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
          todoC,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(ClearCompletedAction());

      verify(todosRepository.deleteTodo(store.state.profile.id, [todoB.id, todoC.id]));
    });
  });
}
