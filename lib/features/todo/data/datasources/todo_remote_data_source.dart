import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/features/todo/data/models/todo_model.dart';

abstract interface class TodoRemoteDataSource {
  Future<TodoModel> uploadTodo(TodoModel todo);
  Future<List<TodoModel>> getAllTodos();
  Future<void> deleteTodo(String todoId);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final FirebaseFirestore firebaseInstance;
  TodoRemoteDataSourceImpl(this.firebaseInstance);

  @override
  Future<TodoModel> uploadTodo(TodoModel todo) async {
    try {
      final todoData = todo.toJson();
      final todosRef = FirebaseFirestore.instance.collection('todos');
      await todosRef.doc(todo.id).set(todoData);
      return todo;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final todoSnapshot = await FirebaseFirestore.instance.collection("todos").get();
      List<TodoModel> todos = await Future.wait(
          todoSnapshot.docs.map((todoDoc) async {
            final todoData = todoDoc.data();
            String posterName = 'Unknown';
            if (todoData['poster_id'] != null) {
              final profileSnapshot = await FirebaseFirestore.instance
                  .collection("profiles")
                  .doc(todoData['poster_id'])
                  .get();
              if (profileSnapshot.exists) {
                posterName = profileSnapshot.data()?['name'] ?? 'Unknown';
              }
            }
            return TodoModel.fromJson(todoData).copyWith(
              posterName: posterName,
            );
          }).toList(),
      );
      return todos;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    try {
      FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
