import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textfields/email_textformfield.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textfields/password_textformfield.dart';
import 'package:volunteerexpress/frontend/decorations/form_decoration.dart';

import 'dart:developer' as dev show log;

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
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
    late final user;
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
                    ? const Icon(Icons.visibility) // Eye icon
                    : const Icon(Icons.visibility_off), // Eye with slash icon
              ),
            ),

            // Spacing
            const SizedBox(height: 50),

            // Log in button
            SizedBox(
              width: 250,
              child: DefaultTextButton(
                onPressed: () async {
                  // ******************************************************
                  // ****** CODE THAT CONNECTS BACKEND TO FRONTEND ********
                  // ******************************************************
                  //
                  if (widget.formKey.currentState!.validate()) {
                    final email = widget.emailController.text;
                    final password = widget.passwordController.text;
                    try {
                      user = await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      //
                      // *****CHECK FOR EMAIL VERIFICATION IN THE FUTURE*****
                      //

                      // Unimplemented exceptions
                    } on UserNotLoggedInAuthException {
                      dev.log('user not logged in');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No user found. Please check your credentials.'),
                            backgroundColor:
                                Colors.red, // Optional: Set a color
                          ),
                        );
                      } //placeholder
                    } on InvalidCredentialAuthException {
                      dev.log('invalid credential');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No user found. Please check your credentials.'),
                            backgroundColor:
                                Colors.red, // Optional: Set a color
                          ),
                        );
                      } //pladeholder
                    } on GenericAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No user found. Please check your credentials.'),
                            backgroundColor:
                                Colors.red, // Optional: Set a color
                          ),
                        );
                      }
                      dev.log(e.toString()); //placeholder
                    }

                    // *******************************************************
                    // *******************************************************
                    //
                    // Go to profile page on button press
                    if (user != null) {
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          homePageRoute,
                          (route) => false,
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No user found. Please check your credentials.'),
                            backgroundColor:
                                Colors.red, // Optional: Set a color
                          ),
                        );
                      }
                    }
                  }
                },
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
