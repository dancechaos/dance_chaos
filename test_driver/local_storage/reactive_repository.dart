// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:dance_chaos/app/repo/reactive_repository.dart';
import 'package:dance_chaos/app/repo/todo_entity.dart';
import 'package:dance_chaos/app/repo/todos_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Todos and Persist todos.
class ReactiveLocalStorageRepository implements ReactiveTodosRepository {
  final TodosRepository _repository;
  final BehaviorSubject<List<TodoEntity>> _subject;
  bool _loaded = false;

  ReactiveLocalStorageRepository({
    @required TodosRepository repository,
    List<TodoEntity> seedValue,
  })  : _repository = repository,
        _subject = seedValue != null
            ? BehaviorSubject<List<TodoEntity>>.seeded(seedValue)
            : BehaviorSubject<List<TodoEntity>>();

  @override
  Future<void> addNewTodo(String profileId, TodoEntity todo) async {
    _subject.add([..._subject.value, todo]);

    await _repository.saveTodos(profileId, _subject.value);
  }

  @override
  Future<void> deleteTodo(String profileId, List<String> idList) async {
    _subject.add(
      List<TodoEntity>.unmodifiable(_subject.value.fold<List<TodoEntity>>(
        <TodoEntity>[],
        (prev, entity) {
          return idList.contains(entity.id) ? prev : (prev..add(entity));
        },
      )),
    );

    await _repository.saveTodos(profileId, _subject.value);
  }

  @override
  Stream<List<TodoEntity>> todos(String profileId) {
    if (!_loaded) _loadTodos(profileId);

    return _subject.stream;
  }

  void _loadTodos(String profileId) {
    _loaded = true;

    _repository.loadTodos(profileId).then((entities) {
      _subject.add(List<TodoEntity>.unmodifiable(
        [if (_subject.value != null) ..._subject.value, ...entities],
      ));
    });
  }

  @override
  Future<void> updateTodo(String profileId, TodoEntity update) async {
    _subject.add(
      List<TodoEntity>.unmodifiable(_subject.value.fold<List<TodoEntity>>(
        <TodoEntity>[],
        (prev, entity) => prev..add(entity.id == update.id ? update : entity),
      )),
    );

    await _repository.saveTodos(profileId, _subject.value);
  }
}
