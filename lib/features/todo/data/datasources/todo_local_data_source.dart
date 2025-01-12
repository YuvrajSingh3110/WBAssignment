import 'package:task_app/features/todo/data/models/todo_model.dart';
import 'package:hive/hive.dart';

abstract interface class TodoLocalDataSource {
  void uploadLocalTodos({required List<TodoModel> todos});
  List<TodoModel> loadTodos();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box box;
  TodoLocalDataSourceImpl(this.box);

  @override
  List<TodoModel> loadTodos() {
    List<TodoModel> todos = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        todos.add(TodoModel.fromJson(box.get(i.toString())));
      }
    });

    return todos;
  }

  @override
  void uploadLocalTodos({required List<TodoModel> todos}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < todos.length; i++) {
        box.put(i.toString(), todos[i].toJson());
      }
    });
  }
}