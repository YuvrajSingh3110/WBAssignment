import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/network/connecttion_checker.dart';
import 'package:task_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:task_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:task_app/features/todo/data/models/todo_model.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';
import 'package:task_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource todoRemoteDataSource;
  final TodoLocalDataSource todoLocalDataSource;
  final ConnectionChecker connectionChecker;
  TodoRepositoryImpl(
      this.todoRemoteDataSource,
      this.todoLocalDataSource,
      this.connectionChecker,
      );

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final todos = todoLocalDataSource.loadTodos();
        return right(todos);
      }
      final todos = await todoRemoteDataSource.getAllTodos();
      todoLocalDataSource.uploadLocalTodos(todos: todos);
      return right(todos);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, Todo>> uploadTodo(
      {required String title,
      required String content,
      required String posterId,
      required String dueDate,
      required String priority}) async {
    try {
      TodoModel todoModel = TodoModel(
        id: const Uuid().v1(),
        todoId: posterId,
        title: title,
        content: content,
        dueDate: dueDate,
        priority: priority,
        updatedAt: DateTime.now(),
      );

      final uploadedTodo = await todoRemoteDataSource.uploadTodo(todoModel);
      return right(uploadedTodo);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String todoId) async {
    try {
      await todoRemoteDataSource.deleteTodo(todoId);
      return Right(null);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
