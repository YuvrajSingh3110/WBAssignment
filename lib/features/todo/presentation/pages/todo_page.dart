import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/common/widgets/loader.dart';
import 'package:task_app/core/theme/app_pallete.dart';
import 'package:task_app/core/utils/format_date.dart';
import 'package:task_app/core/utils/snackbar.dart';
import 'package:task_app/features/todo/domain/entities/todo.dart';
import 'package:task_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:task_app/features/todo/presentation/pages/add_new_todo_page.dart';
import 'package:task_app/features/todo/presentation/widgets/todo_card.dart';

class TodoPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TodoPage(),
      );
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String todaysDate = '';
  String selectedSortOrder = "Ascending";

  @override
  void initState() {
    super.initState();
    todaysDate = getTodaysDate();
    context.read<TodoBloc>().add(TodoFetchAllTodos());
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case "Today":
        return AppPallete.gradient1;
      case "Tomorrow":
        return AppPallete.gradient2;
      case "This Week":
        return AppPallete.gradient3;
      default:
        return AppPallete.whiteColor;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Map<String, List<Todo>> _categorizeTodosByDueDate(List<Todo> todos) {
    final Map<String, List<Todo>> groupedTodos = {
      "Today": [],
      "Tomorrow": [],
      "This Week": [],
      "Others": [],
    };

    for (var todo in todos) {
      print(todo.dueDate);
      switch (todo.dueDate) {
        case "Today":
          groupedTodos["Today"]!.add(todo);
          break;
        case "Tomorrow":
          groupedTodos["Tomorrow"]!.add(todo);
          break;
        case "This Week":
          groupedTodos["This Week"]!.add(todo);
          break;
        default:
          groupedTodos["Others"]!.add(todo);
          break;
      }
    }

    return groupedTodos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today $todaysDate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "My Tasks",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTodoPage.route());
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoFailure) {
            showSnackBar(context, state.error);
          } else if (state is TodoDeleteSuccess) {
            showSnackBar(context, "Todo deleted successfully!!!");
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Loader();
          }
          if (state is TodosDisplaySuccess) {
            final todosByDate = _categorizeTodosByDueDate(state.todos);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sort by Priority",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      DropdownButton<String>(
                        value: selectedSortOrder,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSortOrder = value;
                            });
                            context
                                .read<TodoBloc>()
                                .add(TodoSortByPriority(value));
                          }
                        },
                        items: ["Ascending", "Descending"]
                            .map(
                              (order) => DropdownMenuItem(
                                value: order,
                                child: Text(order),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (var category in [
                        "Today",
                        "Tomorrow",
                        "This Week",
                        "Others"
                      ])
                        if (todosByDate[category]!.isNotEmpty) ...[
                          _buildSectionHeader(category),
                          ...todosByDate[category]!.map(
                            (todo) => TodoCard(
                              todo: todo,
                              color: _getColorForCategory(category),
                              onDelete: () {
                                context
                                    .read<TodoBloc>()
                                    .add(TodoDelete(todo.id));
                              },
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
