import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'todo_detail_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TodoItem> todos = dummyTodos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // このメソッドはダミーの実装です。後でRiverpodで置き換えます
  void _deleteTodo(String id) {
    setState(() {
      todos = todos.where((todo) => todo.id != id).toList();
    });
  }

  List<TodoItem> _getFilteredTodos(TodoStatus? status) {
    if (status == null) {
      return todos;
    }
    return todos.where((todo) => todo.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'すべて'),
            Tab(text: 'Todo'),
            Tab(text: '進行中'),
            Tab(text: '完了'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodoList(null),
          _buildTodoList(TodoStatus.todo),
          _buildTodoList(TodoStatus.inProgress),
          _buildTodoList(TodoStatus.done),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoDetailScreen(todo: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList(TodoStatus? filterStatus) {
    final filteredTodos = _getFilteredTodos(filterStatus);

    if (filteredTodos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              filterStatus == null
                  ? 'TODOがありません'
                  : '${_getStatusText(filterStatus)}のTODOがありません',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTodos.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return TodoItemWidget(
          todo: todo,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailScreen(todo: todo),
              ),
            );
          },
          onDelete: () => _deleteTodo(todo.id),
        );
      },
    );
  }

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.todo:
        return 'Todo';
      case TodoStatus.inProgress:
        return '進行中';
      case TodoStatus.done:
        return '完了';
    }
  }
}
