import 'package:flutter/material.dart';

class TodoEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const TodoEditor({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
