// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:redux/redux.dart';

final todosReducer = combineReducers<List<Todo>>([
  TypedReducer<List<Todo>, LoadTodosAction>(_setLoadedTodos),
  TypedReducer<List<Todo>, DeleteTodoAction>(_deleteTodo),
]);

List<Todo> _setLoadedTodos(List<Todo> todos, LoadTodosAction action) {
  return action.todos;
}

List<Todo> _deleteTodo(List<Todo> todos, DeleteTodoAction action) {
  return todos..removeWhere((todo) => todo.id == action.id);
}
