// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/selectors/selectors.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('Selectors', () {
    test('should list the active todos', () {
      final todoA = Todo(note: 'a');
      final todoB = Todo(note: 'b');
      final todos = [
        todoA,
        todoB,
        Todo(note: 'c', complete: true),
      ];

      expect(activeTodosSelector(todos), [todoA, todoB]);
    });

    test('should calculate the number of active todos', () {
      final todos = [
        Todo(note: 'a'),
        Todo(note: 'b'),
        Todo(note: 'c', complete: true),
      ];

      expect(numActiveSelector(todos), 2);
    });

    test('should list the completed todos', () {
      final todo = Todo(note: 'c', complete: true);
      final todos = [
        Todo(note: 'a'),
        Todo(note: 'b'),
        todo,
      ];

      expect(completeTodosSelector(todos), [todo]);
    });

    test('should calculate the number of completed todos', () {
      final todos = [
        Todo(note: 'a'),
        Todo(note: 'b'),
        Todo(note: 'c', complete: true),
      ];

      expect(numCompletedSelector(todos), 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        Todo(note: 'a'),
        Todo(note: 'b'),
        Todo(note: 'c', complete: true),
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.all), todos);
    });

    test('should return active todos if the VisibilityFilter is active', () {
      final todo1 = Todo(note: 'a');
      final todo2 = Todo(note: 'b');
      final todo3 = Todo(note: 'c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.active), [
        todo1,
        todo2,
      ]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () {
      final todo1 = Todo(note: 'a');
      final todo2 = Todo(note: 'b');
      final todo3 = Todo(note: 'c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(filteredTodosSelector(todos, VisibilityFilter.completed), [todo3]);
    });

    test('should return an Optional todo based on id', () {
      final todo1 = Todo(note: 'a', id: '1');
      final todo2 = Todo(note: 'b');
      final todo3 = Todo(note: 'c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, '1'), Optional.of(todo1));
    });

    test('should return an absent Optional if the id is not found', () {
      final todo1 = Todo(note: 'a', id: '1');
      final todo2 = Todo(note: 'b');
      final todo3 = Todo(note: 'c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];

      expect(todoSelector(todos, '2'), Optional.absent());
    });
  });
}
