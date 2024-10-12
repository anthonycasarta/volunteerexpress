import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class TextOnlyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final double? fontSize;
  final Color buttonColor;

  const TextOnlyButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.fontSize = 15,
    this.buttonColor = primaryAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(
            buttonColor,
          ),
          overlayColor: const WidgetStatePropertyAll<Color>(
            secondaryAccentColor,
          )),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
