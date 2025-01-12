import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Color color;
  final VoidCallback onDelete;
  const TodoCard({
    super.key,
    required this.todo,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.push(context, TodoViewerPage.route(blog));
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(label: Text(todo.priority)),
              ],
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                CupertinoIcons.delete,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
