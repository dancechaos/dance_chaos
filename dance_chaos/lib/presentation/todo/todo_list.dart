// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/app/core/keys.dart';
import 'package:dance_chaos_data/app/core/localization.dart';
import 'package:dance_chaos/containers/tabs/app_loading.dart';
import 'package:dance_chaos/containers/todo/todo_details.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos/presentation/loading_indicator.dart';
import 'package:dance_chaos/presentation/todo/todo_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo, bool) onCheckboxChanged;
  final Function(Todo) onRemove;
  final Function(Todo) onUndoRemove;

  TodoList({
    Key key,
    @required this.todos,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, loading) {
      return loading
          ? LoadingIndicator(key: ArchSampleKeys.todosLoading)
          : _buildListView();
    });
  }

  ListView _buildListView() {
    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return TodoItem(
          todo: todo,
          onDismissed: (direction) {
            _removeTodo(context, todo);
          },
          onTap: () => _onTodoTap(context, todo),
          onCheckboxChanged: (complete) {
            onCheckboxChanged(todo, complete);
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    onRemove(todo);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => onUndoRemove(todo),
        )));
  }

  void _onTodoTap(BuildContext context, Todo todo) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (_) => TodoDetails(id: todo.id),
    ))
        .then((removedTodo) {
      if (removedTodo != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: Duration(seconds: 2),
            content: Text(
              ArchSampleLocalizations.of(context).todoDeleted(todo.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                onUndoRemove(todo);
              },
            )));
      }
    });
  }
}
