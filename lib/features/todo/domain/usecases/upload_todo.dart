import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecase/usecase.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';
import 'package:task_app/features/todo/domain/repositories/todo_repository.dart';

class UploadTodo implements UseCase<Todo, UploadTodoParams> {
  final TodoRepository todoRepository;
  UploadTodo(this.todoRepository);

  @override
  Future<Either<Failure, Todo>> call(UploadTodoParams params) async {
    return await todoRepository.uploadTodo(
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      dueDate: params.dueDate,
      priority: params.priority,
    );
  }
}

class UploadTodoParams {
  final String posterId;
  final String title;
  final String content;
  final String dueDate;
  final String priority;

  UploadTodoParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.dueDate,
    required this.priority,
  });
}