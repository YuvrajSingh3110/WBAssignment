import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';

abstract interface class TodoRepository {
  Future<Either<Failure, Todo>> uploadTodo({
    required String title,
    required String content,
    required String posterId,
    required String dueDate,
    required String priority,
  });

  Future<Either<Failure, List<Todo>>> getAllTodos();

  Future<Either<Failure, void>> deleteTodo(String todoId);
}