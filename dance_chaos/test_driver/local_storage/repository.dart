// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:dance_chaos/app/entity/todo_entity.dart';
import 'package:dance_chaos/app/repo/todos_repository.dart';
import 'package:meta/meta.dart';
import 'web_client.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
class LocalStorageRepository implements TodosRepository {
  final TodosRepository localStorage;
  final TodosRepository webClient;

  const LocalStorageRepository({
    @required this.localStorage,
    this.webClient = const WebClient(),
  });

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Client.
  @override
  Future<List<TodoEntity>> loadTodos(String profileId) async {
    try {
      return await localStorage.loadTodos(profileId);
    } catch (e) {
      final todos = await webClient.loadTodos(profileId);

      await localStorage.saveTodos(profileId, todos);

      return todos;
    }
  }

  // Persists todos to local disk and the web
  @override
  Future saveTodos(String profileId, List<TodoEntity> todos) {
    return Future.wait<dynamic>([
      localStorage.saveTodos(profileId, todos),
      webClient.saveTodos(profileId, todos),
    ]);
  }
}
