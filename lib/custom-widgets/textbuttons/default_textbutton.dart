import 'package:flutter/material.dart';
import 'package:volunteerexpress/themes/colors.dart';

class DefaultTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? fontSize;
  final Color buttonColor;
  final double borderRadius;

  const DefaultTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.fontSize = 20,
    this.buttonColor = primaryAccentColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll<Color>(
          textColorLight,
        ),
        backgroundColor: WidgetStatePropertyAll<Color>(
          buttonColor,
        ),
        overlayColor: const WidgetStatePropertyAll(
          secondaryAccentColor,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
