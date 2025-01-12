class Todo {
  final String id;
  final String todoId;
  final String title;
  final String content;
  final String dueDate;
  final String priority;
  final DateTime updatedAt;
  final String? posterName;

  Todo({
    required this.id,
    required this.todoId,
    required this.title,
    required this.content,
    required this.dueDate,
    required this.priority,
    required this.updatedAt,
    this.posterName,
  });
}