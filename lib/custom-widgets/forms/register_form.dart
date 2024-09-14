import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textfields/email_text_form_field.dart';
import 'package:volunteerexpress/custom-widgets/textfields/password_text_form_field.dart';
import 'package:volunteerexpress/decorations/form_decoration.dart';

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
  late bool _isObscured; // Holds obscure state

  @override
  void initState() {
    _isObscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormDecoration(
      form: Form(
        key: widget.formKey, // Key for validation
        child: Column(
          children: [
            // spacing
            const SizedBox(height: 50),

            // Email field
            EmailTextFormField(
              controller: widget.emailController,
            ),

            // Spacing
            const SizedBox(height: 20),

            // Password field
            PasswordTextFormField(
              obscureText: _isObscured,
              isConfirmPass: false,
              controller: widget.passwordController,
              hintText: 'Password',
            ),

            // Spacing
            const SizedBox(height: 20),

            // Confirm Password field
            PasswordTextFormField(
              obscureText: _isObscured,
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
