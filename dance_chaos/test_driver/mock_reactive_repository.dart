// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/profile_entity.dart';
import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:dance_chaos_data/app/entity/user_entity.dart';
import 'package:dance_chaos_data/app/repo/profile_repository.dart';
import 'package:dance_chaos_data/app/repo/reactive_repository.dart';
import 'package:dance_chaos_data/app/repo/user_repository.dart';
import 'package:dance_chaos_data/models/profile.dart';
import 'local_storage/web_client.dart';
import '../test/test_data.dart';

class MockUserRepository implements UserRepository {
  // ignore: close_sinks
  final userController = StreamController<UserEntity>();
  // ignore: close_sinks
  final locationController = StreamController<GeoPoint>();

  @override
  Future<void> initApp([
    delayAuth = const Duration(milliseconds: 200),
  ]) {
    return Future<void>.delayed(delayAuth);
  }

  @override
  Stream<UserEntity> userChanges() async* {
    Timer.periodic(Duration(milliseconds: 400), (timer) { });

    yield null; // First sign in is a null user (should trigger an anonymous login)
    // Now return users added to stream

    await for (var latest in userController.stream) {
      yield latest;
    }
  }

  @override
  Future<GeoPoint> getCurrentLocation() {
    final delayAuth = const Duration(milliseconds: 200);
      return Future<GeoPoint>.delayed(delayAuth).whenComplete(() {
        return GeoPoint(53.814167, -3.050278);
      });
  }

  @override
  Stream<GeoPoint> locationChanges() async* {
    Timer.periodic(Duration(milliseconds: 400), (timer) { });

    yield null; // First sign in is a null user (should trigger an anonymous login)
    // Now return users added to stream

    await for (var latest in locationController.stream) {
      yield latest;
    }
  }

  @override
  Future<UserEntity> signIn({String user, String password}) {
    final delayAuth = const Duration(milliseconds: 200);
    return Future<UserEntity>.delayed(delayAuth).whenComplete((){
      if (user == null)
        userController.add(TestData.anonUserEntity);  // Trigger an anonymous login
      else
        userController.add(TestData.userEntity);  // Trigger an anonymous login
    });
  }
}

class MockProfileRepository implements ProfileRepository {
  // ignore: close_sinks
  final profileController = StreamController<ProfileEntity>();

  @override
  Future<ProfileEntity> getProfile(UserEntity userEntity) {
      ProfileEntity profileEntity = Profile.fromEntity(userEntity).toEntity();
      addNewProfile(profileEntity);
      Timer(Duration(milliseconds: 600), () {
        profileController.add(TestData.profileEntity);  // Trigger a profile read
      });
      return Future<ProfileEntity>.delayed(delayAuth, () {
        return profileEntity;
      },
    );
  }

  @override
  Stream<ProfileEntity> profileChanges(String id) async* {
    Timer.periodic(Duration(milliseconds: 400), (timer) { });

    // Now return profiles added to stream
    await for (var latest in profileController.stream) {
      yield latest;
    }
  }

  @override
  Future<void> addNewProfile(ProfileEntity profile) {
    return Future<void>.delayed(delayAuth); // Added!
  }

  @override
  Future<void> deleteProfile(String id) {
    // TODO: implement deleteProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return Future<void>.delayed(delayAuth); // Updated!
  }
  final delayAuth = const Duration(milliseconds: 200);

}

class MockReactiveTodosRepository implements ReactiveTodosRepository {
  // ignore: close_sinks
  final controller = StreamController<List<TodoEntity>>();
  List<TodoEntity> _todos = [];

  @override
  Future<void> addNewTodo(String profileId, TodoEntity newTodo) async {
    _todos.add(newTodo);
    controller.add(_todos);
  }

  @override
  Future<List<void>> deleteTodo(String profileId, List<String> idList) async {
    _todos.removeWhere((todo) => idList.contains(todo.id));
    controller.add(_todos);

    return [];
  }

  @override
  Stream<List<TodoEntity>> todos(String profileId, {webClient = const WebClient()}) async* {
    _todos = await webClient.loadTodos(profileId);

    yield _todos;

    await for (var latest in controller.stream) {
      yield latest;
    }
  }

  @override
  Future<void> updateTodo(String profileId, TodoEntity todo) async {
    _todos[_todos.indexWhere((t) => t.id == todo.id)] = todo;

    controller.add(_todos);
  }
}
