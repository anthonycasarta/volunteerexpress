import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const PasswordTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
