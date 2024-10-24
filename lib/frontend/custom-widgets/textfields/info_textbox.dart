import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class InfoTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isRequired;
  final int? maxLength;
  final bool isMultiline;

  const InfoTextBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isRequired = false,
    this.maxLength,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: isMultiline ? null : 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixText: isRequired ? '*' : null, // Mark required fields with *
      ),
      style: const TextStyle(
        fontSize: 18,
        color: textColorDark,
      ),
    );
  }
}
