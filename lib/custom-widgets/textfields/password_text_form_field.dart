import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextEditingController? compareController;
  final bool isConfirmPass;

  const PasswordTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isConfirmPass,
    this.compareController,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a Password';
        } else if (isConfirmPass) {
          if (controller != compareController) {
            return 'Passwords do not match';
          }
        }
        return null;
      },
    );
  }
}
