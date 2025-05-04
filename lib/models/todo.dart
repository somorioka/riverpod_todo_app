import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'todo.freezed.dart';

enum TodoStatus {
  todo,
  inProgress,
  done;

  String getStatusText() {
    switch (this) {
      case TodoStatus.todo:
        return 'Todo';
      case TodoStatus.inProgress:
        return '進行中';
      case TodoStatus.done:
        return '完了';
    }
  }
}

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String description,
    required TodoStatus status,
    required DateTime createdAt,
  }) = _Todo;
}
