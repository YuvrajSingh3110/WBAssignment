part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class TodoUpload extends TodoEvent {
  final String todoId;
  final String title;
  final String content;
  final String dueDate;
  final String priority;

  TodoUpload({
    required this.todoId,
    required this.title,
    required this.content,
    required this.dueDate,
    required this.priority,
  });
}

final class TodoFetchAllTodos extends TodoEvent {}

class TodoSortByPriority extends TodoEvent {
  final String sortOrder;
  TodoSortByPriority(this.sortOrder);
}

final class TodoDelete extends TodoEvent {
  final String todoId;

  TodoDelete(this.todoId);
}