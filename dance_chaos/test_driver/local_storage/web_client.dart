// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:dance_chaos_data/app/repo/todos_repository.dart';

/// A class that is meant to represent a Client that would be used to call a Web
/// Service. It is responsible for fetching and persisting Todos to and from the
/// cloud.
///
/// Since we're trying to keep this example simple, it doesn't communicate with
/// a real server but simply emulates the functionality.
class WebClient implements TodosRepository {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  /// Mock that "fetches" some Todos from a "web service" after a short delay
  @override
  Future<List<TodoEntity>> loadTodos(profileId) async {
    return Future.delayed(
        delay,
        () => [
              TodoEntity(
                task: 'Buy food for da kitty',
                id: '1',
                note: 'With the chickeny bits!',
                complete: false,
              ),
              TodoEntity(
                task: 'Find a Red Sea dive trip',
                id: '2',
                note: 'Echo vs MY Dream',
                complete: false,
              ),
              TodoEntity(
                task: 'Book flights to Egypt',
                id: '3',
                note: '',
                complete: true,
              ),
              TodoEntity(
                task: 'Decide on accommodation',
                id: '4',
                note: '',
                complete: false,
              ),
              TodoEntity(
                task: 'Sip Margaritas',
                id: '5',
                note: 'on the beach',
                complete: true,
              ),
            ]);
  }

  /// Mock that returns true or false for success or failure. In this case,
  /// it will "Always Succeed"
  @override
  Future<bool> saveTodos(String profileId, List<TodoEntity> todos) async {
    return Future.value(true);
  }
}
