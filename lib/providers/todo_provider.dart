import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todo_app/models/todo.dart';
import 'package:uuid/uuid.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  final _uuid = const Uuid();

  @override
  List<Todo> build() {
    // 初期状態ではダミーデータを返す
    return [
      Todo(
        id: '1',
        title: 'Flutterの基礎を学ぶ',
        description: 'Widgetの概念、状態管理、ナビゲーションについて学習する',
        status: TodoStatus.done,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Todo(
        id: '2',
        title: 'Riverpodを理解する',
        description: 'Providerの種類、使い方、StateNotifierの実装方法を理解する',
        status: TodoStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Todo(
        id: '3',
        title: 'TODOアプリを完成させる',
        description: 'Riverpodを使ってTODOアプリの状態管理を実装し、CRUDを完成させる',
        status: TodoStatus.todo,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Todo(
        id: '4',
        title: 'UIをブラッシュアップする',
        description: 'アニメーションを追加し、レスポンシブ対応を行う',
        status: TodoStatus.todo,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // タスクを追加する
  void addTodo(String title, String description, TodoStatus status) {
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      status: status,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
  }

  // タスクを更新する
  void updateTodo(Todo updateTodo) {
    state = state.map((todo) {
      // 該当するIDのTODOのみ更新
      return todo.id == updateTodo.id ? updateTodo : todo;
    }).toList();
  }

  // タスクを削除
  void deleteTodo(String id) {
    // 該当のIDのTODOを削除したTODOリストに更新
    state = state.where((todo) => todo.id != id).toList();
  }

  // ステータスのみ更新
  void updateStatus(String id, TodoStatus newStatus) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(status: newStatus);
      } else {
        return todo;
      }
    }).toList();
  }
}

@riverpod
class SelectedFilter extends _$SelectedFilter {
  @override
  TodoStatus? build() {
    // デフォルトはfilterなし
    return null;
  }

  void setFilter(TodoStatus? status) {
    state = status;
  }
}
