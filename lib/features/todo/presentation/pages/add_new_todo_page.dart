import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:task_app/core/common/widgets/loader.dart';
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/core/theme/app_pallete.dart';
import 'package:task_app/core/utils/snackbar.dart';
import 'package:task_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:task_app/features/todo/presentation/pages/todo_page.dart';
import 'package:task_app/features/todo/presentation/widgets/todo_editor.dart';

class AddNewTodoPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const AddNewTodoPage(),
  );
  const AddNewTodoPage({super.key});

  @override
  State<AddNewTodoPage> createState() => _AddNewTodoPageState();
}

class _AddNewTodoPageState extends State<AddNewTodoPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedDueDate = "";
  String selectedPriority = "";

  void uploadTodo() {
    if (formKey.currentState!.validate() &&
        selectedDueDate.isNotEmpty &&
        selectedPriority.isNotEmpty) {
      final todoId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<TodoBloc>().add(
        TodoUpload(
          todoId: todoId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          dueDate: selectedDueDate,
          priority: selectedPriority,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              uploadTodo();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoFailure) {
            showSnackBar(context, state.error);
          } else if (state is TodoUploadSuccess) {
            showSnackBar(context, "Todo created!!!");
            Navigator.pushAndRemoveUntil(
              context,
              TodoPage.route(),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Due Date", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.dueDate
                            .map(
                              (e) => Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedDueDate.contains(e)) {
                                  selectedDueDate = "";
                                } else {
                                  selectedDueDate = e;
                                }
                                setState(() {});
                              },
                              child: Chip(
                                label: Text(e),
                                color: selectedDueDate.contains(e)
                                    ? const WidgetStatePropertyAll(
                                  AppPallete.gradient1,
                                )
                                    : null,
                                side: selectedDueDate.contains(e)
                                    ? null
                                    : const BorderSide(
                                  color: AppPallete.borderColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Priority", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.priority
                            .map(
                              (e) => Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedPriority.contains(e)) {
                                  selectedPriority = "";
                                } else {
                                  selectedPriority = e;
                                }
                                setState(() {});
                              },
                              child: Chip(
                                label: Text(e),
                                color: selectedPriority.contains(e)
                                    ? const WidgetStatePropertyAll(
                                  AppPallete.gradient1,
                                )
                                    : null,
                                side: selectedPriority.contains(e)
                                    ? null
                                    : const BorderSide(
                                  color: AppPallete.borderColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Title", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                    const SizedBox(
                      height: 5,
                    ),
                    TodoEditor(
                      controller: titleController,
                      hintText: 'Todo Title',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Description", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                    const SizedBox(
                      height: 5,
                    ),
                    TodoEditor(
                      controller: contentController,
                      hintText: 'Todo Description',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
