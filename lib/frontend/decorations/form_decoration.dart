import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class FormDecoration extends StatelessWidget {
  final Widget form;
  const FormDecoration({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          // Left edge
          left: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
          // Right edge
          right: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
          // Top edge
          top: BorderSide(
            color: primaryAccentColor,
            width: 1,
          ),
          // Bottom edge
          bottom: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
        ),
        // corner curvatoure
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: fadedPrimaryColor,
      ),
      // Space from the edge of the screen
      padding: const EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      child: form, // Form widget
    );
  }
}
