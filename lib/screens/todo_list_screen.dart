import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/providers/todo_provider.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'todo_detail_screen.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        TodoStatus? newFilter;
        switch (_tabController.index) {
          case 0: // すべて
            newFilter = null;
            break;
          case 1: // Todo
            newFilter = TodoStatus.todo;
            break;
          case 2: // 進行中
            newFilter = TodoStatus.inProgress;
            break;
          case 3: // 完了
            newFilter = TodoStatus.done;
            break;
        }

        // フィルター更新
        ref.read(selectedFilterProvider.notifier).setFilter(newFilter);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        children: const [
          TodoListWidget(filterStatus: null),
          TodoListWidget(filterStatus: TodoStatus.todo),
          TodoListWidget(filterStatus: TodoStatus.inProgress),
          TodoListWidget(filterStatus: TodoStatus.done),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoDetailScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoListWidget extends ConsumerWidget {
  final TodoStatus? filterStatus;

  const TodoListWidget({super.key, this.filterStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Todo> todos;
    if (filterStatus == null) {
      todos = ref.watch(todoListProvider);
    } else {
      todos = ref
          .watch(todoListProvider)
          .where((todo) => todo.status == filterStatus)
          .toList();
    }

    if (todos.isEmpty) {
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
                  ? 'タスクがありません'
                  : '${TodoStatus.getStatusText(filterStatus ?? TodoStatus.todo)}のタスクがありません',
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
      itemCount: todos.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItemWidget(
          todo: todo,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoDetailScreen(todoId: todo.id),
              ),
            );
          },
          onDelete: () =>
              ref.read(todoListProvider.notifier).deleteTodo(todo.id),
        );
      },
    );
  }
}
