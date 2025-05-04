// TODO: 後でfreezedを使って実装する

enum TodoStatus {
  todo,
  inProgress,
  done,
}

// ダミーデータ用の簡易TodoItemクラス
class TodoItem {
  final String id;
  final String title;
  final String description;
  final TodoStatus status;
  final DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}

// ダミーデータ
final List<TodoItem> dummyTodos = [
  TodoItem(
    id: '1',
    title: 'Flutterの基礎を学ぶ',
    description: 'Widgetの概念、状態管理、ナビゲーションについて学習する',
    status: TodoStatus.done,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  TodoItem(
    id: '2',
    title: 'Riverpodを理解する',
    description: 'Providerの種類、使い方、StateNotifierの実装方法を理解する',
    status: TodoStatus.inProgress,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  TodoItem(
    id: '3',
    title: 'TODOアプリを完成させる',
    description: 'Riverpodを使ってTODOアプリの状態管理を実装し、CRUDを完成させる',
    status: TodoStatus.todo,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  TodoItem(
    id: '4',
    title: 'UIをブラッシュアップする',
    description: 'アニメーションを追加し、レスポンシブ対応を行う',
    status: TodoStatus.todo,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
