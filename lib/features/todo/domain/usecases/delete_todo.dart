import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecase/usecase.dart';
import 'package:task_app/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodo implements UseCase<void, DeleteTodoParams> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTodoParams params) {
    return repository.deleteTodo(params.todoId);
  }
}

class DeleteTodoParams {
  final String todoId;

  DeleteTodoParams(this.todoId);
}