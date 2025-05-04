import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoDetailScreen extends StatefulWidget {
  final TodoItem? todo;

  const TodoDetailScreen({super.key, this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TodoStatus _status;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    _status = widget.todo?.status ?? TodoStatus.todo;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // これらのメソッドはダミーの実装です。後でRiverpodで置き換えます
  void _saveTodo() {
    if (!_formKey.currentState!.validate()) return;

    // Riverpodの実装時にデータ保存ロジックに置き換えます
    Navigator.pop(context);
  }

  void _deleteTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「${widget.todo!.title}」を削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              // Riverpodの実装時に削除ロジックに置き換えます
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
    final bool isEditing = widget.todo != null;

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
            if (isEditing) ...[
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
                        DateFormat('yyyy年MM月dd日 HH:mm')
                            .format(widget.todo!.createdAt),
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
