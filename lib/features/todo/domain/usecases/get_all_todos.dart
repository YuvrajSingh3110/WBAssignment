import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/error/failures.dart';
import 'package:task_app/core/usecase/usecase.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';
import 'package:task_app/features/todo/domain/repositories/todo_repository.dart';

class GetAllTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository todoRepository;
  GetAllTodos(this.todoRepository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) async {
    return await todoRepository.getAllTodos();
  }
}