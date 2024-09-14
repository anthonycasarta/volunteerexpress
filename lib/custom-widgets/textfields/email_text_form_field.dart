import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Email',
        labelText: 'Email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '**Enter an Email**';
        }
        return null;
      },
    );
  }
}
