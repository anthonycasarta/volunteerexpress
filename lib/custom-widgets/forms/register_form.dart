import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textfields/email_text_form_field.dart';
import 'package:volunteerexpress/custom-widgets/textfields/password_text_form_field.dart';
import 'package:volunteerexpress/themes/colors.dart';

class RegisterForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final GlobalKey<FormState> formKey;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
          right: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
          top: BorderSide(
            color: primaryAccentColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: primaryAccentColor,
            width: 2.5,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: fadedPrimaryColor,
      ),
      padding: const EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      child: Form(
        key: widget.formKey, // Key for validation
        child: Column(
          children: [
            // spacing
            const SizedBox(height: 20),

            // Email field
            EmailTextFormField(
              controller: widget.emailController,
            ),

            // Spacing
            const SizedBox(height: 20),

            // Password field
            PasswordTextFormField(
              isConfirmPass: false,
              controller: widget.passwordController,
              hintText: 'Password',
            ),

            // Spacing
            const SizedBox(height: 20),

            // Confirm Password field
            PasswordTextFormField(
              isConfirmPass: true,
              hintText: 'Confirm Password',
              controller: widget.confirmPasswordController,
            ),

            // Spacing
            const SizedBox(height: 50),

            // Register button
            SizedBox(
              width: 250,
              child: DefaultTextButton(
                onPressed: () {
                  widget.formKey.currentState!.validate(); // validtion
                },
                label: 'Register',
              ),
            ),

            // spacing
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
