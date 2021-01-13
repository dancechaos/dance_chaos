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
      COMPLETE: complete,
      TASK: task,
      NOTE: note,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{$COMPLETE: $complete, $TASK: $task, $NOTE: $note, $ID: $id}';
  }

  static TodoEntity fromJson(String id, Map<String, Object> json) {
    return TodoEntity(
      id: id ?? json[ID] as String,
      task: json[TASK] as String,
      note: json[NOTE] as String,
      complete: json[COMPLETE] as bool,
    );
  }
}
