import 'package:flutter/material.dart';
import 'package:volunteerexpress/enums/auth_enums.dart';
import 'package:volunteerexpress/themes/colors.dart';

class FormListTile extends StatelessWidget {
  final Auth auth;
  final Auth authValue;

  final ValueChanged<Auth?> onChanged;

  final String title;
  const FormListTile({
    super.key,
    required this.auth,
    required this.authValue,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Shape of heading
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: primaryAccentColor,
          width: 3.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),

      // Heading style
      tileColor: auth == authValue
          ? fadedPrimaryColorSaturated
          : unfocusedSecondaryAccentColor,
      title: Text(
        title,
        style: TextStyle(
          color: auth == authValue ? textColorLight : textColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Leading button
      leading: Radio(
        activeColor: textColorLight,
        value: authValue,
        groupValue: auth,
        onChanged: onChanged,
      ),
    );
  }
}
