import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textfields/email_text_form_field.dart';
import 'package:volunteerexpress/custom-widgets/textfields/password_text_form_field.dart';
import 'package:volunteerexpress/themes/colors.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      color: fadedColor,
      child: Form(
        child: Column(
          children: [
            EmailTextFormField(
              controller: emailController,
            ),

            // spacing
            const SizedBox(height: 20),

            PasswordTextFormField(
              controller: passwordController,
              hintText: 'Password',
            ),

            // spacing
            const SizedBox(height: 20),

            PasswordTextFormField(
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
            ),

            // spacing
            const SizedBox(height: 50),

            SizedBox(
              width: 250,
              child: DefaultTextButton(
                onPressed: () {},
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
