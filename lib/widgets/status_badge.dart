import 'package:flutter/material.dart';
import '../models/todo.dart';

class StatusBadge extends StatelessWidget {
  final TodoStatus status;
  
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status),
          width: 1,
        ),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.todo:
        return 'Todo';
      case TodoStatus.inProgress:
        return 'In Progress';
      case TodoStatus.done:
        return 'Done';
    }
  }

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.todo:
        return Colors.blue;
      case TodoStatus.inProgress:
        return Colors.amber;
      case TodoStatus.done:
        return Colors.green;
    }
  }
}