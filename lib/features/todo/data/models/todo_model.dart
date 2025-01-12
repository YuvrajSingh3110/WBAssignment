import 'package:task_app/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.todoId,
    required super.title,
    required super.content,
    required super.dueDate,
    required super.priority,
    required super.updatedAt,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': todoId,
      'title': title,
      'content': content,
      'dueDate': dueDate,
      'priority': priority,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      todoId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      dueDate: map['dueDate'] as String,
      priority: map['priority'] as String,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  TodoModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? dueDate,
    String? priority,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return TodoModel(
      id: id ?? this.id,
      todoId: posterId ?? this.todoId,
      title: title ?? this.title,
      content: content ?? this.content,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
