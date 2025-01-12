part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoFailure extends TodoState {
  final String error;
  TodoFailure(this.error);
}

final class TodoUploadSuccess extends TodoState {}

final class TodosDisplaySuccess extends TodoState {
  final List<Todo> todos;
  TodosDisplaySuccess(this.todos);
}

final class TodoDeleteSuccess extends TodoState {}