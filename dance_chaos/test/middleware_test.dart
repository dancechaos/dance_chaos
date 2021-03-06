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
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'test_data.dart';

class MockReactiveTodosRepository extends Mock
    implements ReactiveTodosRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockDanceProfileRepository extends Mock implements DanceProfileRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

class Cat {
  Stream<String> getStream() {
    return null;
  }
}
class MockCat extends Mock implements Cat {}

void main() {
  group('Middleware', () {
    test('should log in anonymously start listening for changes', () async {
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
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
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
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

    test('should convert entities to todos', () async {
      // ignore: close_sinks
      final controller = StreamController<List<TodoEntity>>(sync: true);
      final danceProfileController = StreamController<List<DanceProfileEntity>>(sync: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository)
//          ..add(captor),
      );

      when(todosRepository.todos(TestData.profileId)).thenAnswer((_) => controller.stream);
      when(danceProfileRepository.danceProfiles(TestData.profileId)).thenAnswer((_) => danceProfileController.stream);

      store.dispatch(ProfileChangedAction(Profile.fromEntity(TestData.profileEntity)));
      controller.add([TestData.todo.toEntity()]);
      danceProfileController.add([TestData.danceProfileEntity]);

      expect(store.state.todos.length, 1);
      expect(store.state.todos[0].toEntity(), TestData.todoEntity);
    });

    test('should send todos to the repository', () {
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(AddNewTodoAction(TestData.todo));
      verify(todosRepository.addNewTodo(store.state.profile.id, TestData.todo.toEntity()));
    });

    test('should clear the completed todos from the repository', () {
      final todoA = Todo(note: 'A');
      final todoB = Todo(note: 'B', complete: true);
      final todoC = Todo(note: 'C', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
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

    test('should inform the repository to toggle all todos active', () {
      final todoA = Todo(note: 'A', complete: true);
      final todoB = Todo(note: 'B', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(todosRepository
          .updateTodo(store.state.profile.id, todoA.copyWith(complete: false).toEntity()));
      verify(todosRepository
          .updateTodo(store.state.profile.id, todoB.copyWith(complete: false).toEntity()));
    });

    test('should inform the repository to toggle all todos complete', () {
      final todoA = Todo(note: 'A');
      final todoB = Todo(note: 'B', complete: true);
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [
          todoA,
          todoB,
        ]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(todosRepository
          .updateTodo(store.state.profile.id, todoA.copyWith(complete: true).toEntity()));
    });

    test('should update a todo on firestore', () {
      final update = TestData.todo.copyWith(task: 'B');
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [TestData.todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(UpdateTodoAction(TestData.todo.id, update));

      verify(todosRepository.updateTodo(store.state.profile.id, update.toEntity()));
    });

    test('should delete a todo on firestore', () {
      final todosRepository = MockReactiveTodosRepository();
      final userRepository = MockUserRepository();
      final profileRepository = MockProfileRepository();
      final danceProfileRepository = MockDanceProfileRepository();
      final locationRepository = MockLocationRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(todos: [TestData.todo]),
        middleware: createStoreTodosMiddleware(todosRepository, userRepository, profileRepository, danceProfileRepository, locationRepository),
      );

      store.dispatch(DeleteTodoAction(TestData.todo.id));

      verify(todosRepository.deleteTodo(store.state.profile.id, [TestData.todo.id]));
    });
  });
}
