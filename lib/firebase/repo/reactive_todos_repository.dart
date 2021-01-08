// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/repo/reactive_repository.dart';
import 'package:dance_chaos/app/repo/todo_entity.dart';
import 'package:flutter/foundation.dart';

import '../../main.dart';
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
          doc['task'],
          doc.id,
          doc['note'] ?? '',
          doc['complete'] ?? false,
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
