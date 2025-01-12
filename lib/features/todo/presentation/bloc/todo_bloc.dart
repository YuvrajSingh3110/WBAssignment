import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/usecase/usecase.dart';
import 'package:task_app/features/todo/data/models/todo_model.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';
import 'package:task_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:task_app/features/todo/domain/usecases/get_all_todos.dart';
import 'package:task_app/features/todo/domain/usecases/upload_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  static const Map<String, int> priorityOrder = {
    "Low": 0,
    "Medium": 1,
    "High": 2
  };

  final UploadTodo _uploadTodo;
  final GetAllTodos _getAllTodos;
  final DeleteTodo _deleteTodo;
  TodoBloc({
    required UploadTodo uploadTodo,
    required GetAllTodos getAllTodos,
    required DeleteTodo deleteTodo,
  })  : _uploadTodo = uploadTodo,
        _getAllTodos = getAllTodos,
        _deleteTodo = deleteTodo,
        super(TodoInitial()) {
    // on<TodoEvent>((event, emit) => emit(TodoLoading()));
    on<TodoUpload>(_onTodoUpload);
    on<TodoFetchAllTodos>(_onFetchAllTodos);
    on<TodoDelete>(_onTodoDelete);
    on<TodoSortByPriority>(_onTodoSort);
  }

  void _onTodoUpload(
    TodoUpload event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    final res = await _uploadTodo(
      UploadTodoParams(
        posterId: event.todoId,
        title: event.title,
        content: event.content,
        dueDate: event.dueDate,
        priority: event.priority,
      ),
    );

    res.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoUploadSuccess()),
    );
  }

  void _onFetchAllTodos(
    TodoFetchAllTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    final res = await _getAllTodos(NoParams());

    res.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodosDisplaySuccess(r)),
    );
  }

  void _onTodoDelete(
    TodoDelete event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    final res = await _deleteTodo(DeleteTodoParams(event.todoId));

    res.fold(
          (l) => emit(TodoFailure(l.message)),
          (r) {
        emit(TodoDeleteSuccess());
        add(TodoFetchAllTodos());
      },
    );
  }

  void _onTodoSort(
      TodoSortByPriority event,
      Emitter<TodoState> emit,
      ) {
    if (state is TodosDisplaySuccess) {
      final currentState = state as TodosDisplaySuccess;
      final todos = List<TodoModel>.from(currentState.todos);

      todos.sort((a, b) {
        final aPriority = priorityOrder[a.priority] ?? 0;
        final bPriority = priorityOrder[b.priority] ?? 0;
        return event.sortOrder == "Ascending"
            ? aPriority.compareTo(bPriority)
            : bPriority.compareTo(aPriority);
      });
      emit(TodosDisplaySuccess(todos));
    }
  }
}
