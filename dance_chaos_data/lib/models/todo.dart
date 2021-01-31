import 'package:dance_chaos_data/app/core/uuid.dart';
import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:meta/meta.dart';

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

@immutable
class Todo {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo({@required this.task, this.complete = false, String note = '', String id})
      : note = note ?? '',
        id = id ?? Uuid().generateV4();

  Todo copyWith({bool complete, String id, String note, String task}) {
    return Todo(
      task: task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  TodoEntity toEntity() {
    return TodoEntity(id: id, task: task, note: note, complete: complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      task: entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}
