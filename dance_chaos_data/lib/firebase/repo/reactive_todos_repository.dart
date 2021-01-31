// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:dance_chaos_data/app/repo/reactive_repository.dart';

import 'firestore_profile_repository.dart';

class FirestoreReactiveTodosRepository implements ReactiveTodosRepository {
  static const String path = 'todo';

  FirestoreReactiveTodosRepository() : super();

  @override
  Future<void> addNewTodo(String profileId, TodoEntity todo) {
    return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).doc(todo.id).set(todo.toJson());
  }

  @override
  Future<void> deleteTodo(String profileId, List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).doc(id).delete();
    }));
  }

  @override
  Stream<List<TodoEntity>> todos(String profileId) {
    return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoEntity(
          id: doc.id,
          task: doc['task'],
          note: doc['note'] ?? '',
          complete: doc['complete'] ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTodo(String profileId, TodoEntity todo) {
    return FirestoreProfileRepository.firestore()
        .collection(FirestoreProfileRepository.path)
        .doc(profileId)
        .collection(path)
        .doc(todo.id)
        .update(todo.toJson());
  }
}
