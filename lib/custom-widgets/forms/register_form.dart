import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textfields/email_textformfield.dart';
import 'package:volunteerexpress/custom-widgets/textfields/password_textformfield.dart';
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
  late bool _isPassObscured;
  late bool _isConfirmObscured; // Holds obscure state

  @override
  void initState() {
    _isPassObscured = true;
    _isConfirmObscured = true;
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
              obscureText: _isPassObscured,
              isConfirmPass: false,
              controller: widget.passwordController,
              hintText: 'Password',
              suffixIcon: IconButton(
                // Set whether text is hidden or not
                // on button press
                onPressed: () {
                  setState(() {
                    _isPassObscured = !_isPassObscured;
                  });
                },
                icon: _isPassObscured
                    ? const Icon(Icons.visibility) // Eye icon
                    : const Icon(Icons.visibility_off), // Eye with slash icon
              ),
            ),

            // Spacing
            const SizedBox(height: 20),

            // Confirm Password field
            PasswordTextFormField(
              obscureText: _isConfirmObscured,
              isConfirmPass: true,
              hintText: 'Confirm Password',
              controller: widget.confirmPasswordController,
              suffixIcon: IconButton(
                // Set whether text is hidden or not
                // on button press
                onPressed: () {
                  setState(() {
                    _isConfirmObscured = !_isConfirmObscured;
                  });
                },
                icon: _isConfirmObscured
                    ? const Icon(Icons.visibility) // Eye icon
                    : const Icon(Icons.visibility_off), // Eye with slash icon
              ),
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
