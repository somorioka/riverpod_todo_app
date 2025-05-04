import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  final String? todoId;

  const TodoDetailScreen({super.key, this.todoId});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TodoStatus _status;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _status = TodoStatus.todo;

    // 編集モードの場合、初期値を設定
    if (widget.todoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final todo = ref
            .read(todoListProvider)
            .firstWhere((todo) => todo.id == widget.todoId);

        _titleController.text = todo.title;
        _descriptionController.text = todo.description;
        setState(() {
          _status = todo.status;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (!_formKey.currentState!.validate()) return;

    final todoNotifier = ref.read(todoListProvider.notifier);

    if (widget.todoId == null) {
      // 新規作成の場合
      todoNotifier.addTodo(
        _titleController.text,
        _descriptionController.text,
        _status,
      );
    } else {
      // 更新の場合
      final existingTodo = ref
          .read(todoListProvider)
          .firstWhere((todo) => todo.id == widget.todoId);

      final updatedTodo = existingTodo.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status,
      );

      todoNotifier.updateTodo(updatedTodo);
    }

    Navigator.pop(context);
  }

  void _deleteTodo() {
    if (widget.todoId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「${_titleController.text}」を削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(todoListProvider.notifier).deleteTodo(widget.todoId!);
              Navigator.pop(context); // ダイアログを閉じる
              Navigator.pop(context); // 詳細画面を閉じる
            },
            child: const Text(
              '削除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.todoId != null;

    // 編集中のTODOを取得
    final Todo? todo = isEditing
        ? ref
            .watch(todoListProvider)
            .firstWhereOrNull((todo) => todo.id == widget.todoId)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'TODOの編集' : '新規TODO'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTodo,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '説明',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ステータス',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<TodoStatus>(
                      segments: const [
                        ButtonSegment(
                          value: TodoStatus.todo,
                          label: Text('Todo'),
                          icon: Icon(Icons.circle_outlined),
                        ),
                        ButtonSegment(
                          value: TodoStatus.inProgress,
                          label: Text('進行中'),
                          icon: Icon(Icons.pending_outlined),
                        ),
                        ButtonSegment(
                          value: TodoStatus.done,
                          label: Text('完了'),
                          icon: Icon(Icons.check_circle_outline),
                        ),
                      ],
                      selected: {_status},
                      onSelectionChanged: (Set<TodoStatus> newSelection) {
                        setState(() {
                          _status = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isEditing && todo != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '作成日',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('yyyy年MM月dd日 HH:mm').format(todo.createdAt),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saveTodo,
              child: Text(isEditing ? '更新' : '作成'),
            ),
          ],
        ),
      ),
    );
  }
}
