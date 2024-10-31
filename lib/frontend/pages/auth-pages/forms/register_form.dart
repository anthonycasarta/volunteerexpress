import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_exceptions/cloud_user_role_exception.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_user_roles_service.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textfields/email_textformfield.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textfields/password_textformfield.dart';
import 'package:volunteerexpress/frontend/decorations/form_decoration.dart';

import 'dart:developer' as dev show log;

class RegisterForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final GlobalKey<FormState> formKey;

  final String role;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.role,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late bool _isPassObscured;
  late bool _isConfirmObscured; // Holds obscure state

  late final FirebaseUserRolesService _userRolesService;

  @override
  void initState() {
    _isPassObscured = true;
    _isConfirmObscured = true;
    _userRolesService = FirebaseUserRolesService();
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
                onPressed: () async {
                  // ******************************************************
                  // ****** CODE THAT CONNECTS BACKEND TO FRONTEND ********
                  // ******************************************************
                  //
                  // validtion
                  if (widget.formKey.currentState!.validate()) {
                    final email = widget.emailController.text;
                    final password = widget.passwordController.text;
                    try {
                      // Create new user
                      final user = await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );

                      // Assign the user's role
                      _userRolesService.addRole(
                          userId: user.id, userRole: widget.role);
                      //
                      // *****CHECK FOR EMAIL VERIFICATION IN THE FUTURE*****
                      //

                      // Unimplemented exceptions
                    } on EmailAlreadyInUseAuthException {
                      dev.log('email already in use'); //placeholder
                    } on WeakPasswordAuthException {
                      dev.log('weak password'); //placeholder
                    } on InvalidEmailAuthException {
                      dev.log('invalid email'); //placeholder
                    } on GenericAuthException catch (e) {
                      dev.log(e.toString()); //placeholder
                    } on CouldNotAddUserRoleException catch (e) {
                      dev.log(e.toString()); //placeholder
                    }
                  }

                  // *******************************************************
                  // *******************************************************
                  //
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
