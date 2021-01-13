// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

class TodoEntity {
  final String id;
  final String task;
  final String note;
  final bool complete;

  static const ID = 'id';
  static const TASK = 'task';
  static const NOTE = 'note';
  static const COMPLETE = 'complete';

  TodoEntity({this.id, this.task, this.note, this.complete});

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
//      'id': id,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static TodoEntity fromJson(String id, Map<String, Object> json) {
    return TodoEntity(
      id: id ?? json['id'] as String,
      task: json['task'] as String,
      note: json['note'] as String,
      complete: json['complete'] as bool,
    );
  }
}
