import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textfields/email_textformfield.dart';
import 'package:volunteerexpress/custom-widgets/textfields/password_textformfield.dart';
import 'package:volunteerexpress/decorations/form_decoration.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onPressed;

  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onPressed,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late bool _isObscured;

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
              suffixIcon: IconButton(
                // Set whether text is hidden or not
                // on button press
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: _isObscured
                    ? const Icon(Icons.visibility_off) // Eye with slash icon
                    : const Icon(Icons.visibility), // Eye icon
              ),
            ),

            // Spacing
            const SizedBox(height: 50),

            // Register button
            SizedBox(
              width: 250,
              child: DefaultTextButton(
                onPressed: widget.onPressed,
                label: 'Log in',
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
