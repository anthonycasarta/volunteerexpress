import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

import 'dart:developer' as dev show log;

class PasswordTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextEditingController? compareController;
  final bool isConfirmPass;
  final bool obscureText;
  final Widget? suffixIcon;

  const PasswordTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isConfirmPass,
    this.compareController,
    required this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        suffixIcon: suffixIcon,
        fillColor: fadedPrimaryColor,
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '**Enter a Password**';
        } else if (isConfirmPass) {
          dev.log(compareController!.text.toString());
          if (controller.text != compareController!.text) {
            return '**Passwords do not match**';
          }
        }
        return null;
      },
    );
  }
}
