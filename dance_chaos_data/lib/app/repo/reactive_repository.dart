// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:dance_chaos_data/app/entity/todo_entity.dart';

/// A data layer class works with reactive data sources, such as Firebase. This
/// class emits a Stream of TodoEntities. The data layer of the app.
///
/// How and where it stores the entities should defined in a concrete
/// implementation, such as firebase_repository_flutter.
///
/// The domain layer should depend on this abstract class, and each app can
/// inject the correct implementation depending on the environment, such as
/// web or Flutter.
abstract class ReactiveTodosRepository {
  Future<void> addNewTodo(String profileId, TodoEntity todo);

  Future<void> deleteTodo(String profileId, List<String> idList);

  Stream<List<TodoEntity>> todos(String profileId);

  Future<void> updateTodo(String profileId, TodoEntity todo);
}
