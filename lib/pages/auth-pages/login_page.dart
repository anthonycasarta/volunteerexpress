import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 150,
          right: 15,
          left: 15,
        ),
        child: Column(
          children: [
            // Email field
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            // Password field
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            // Login button
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
              ),
              child: SizedBox(
                width: 250,
                child: DefaultTextButton(
                  onPressed: () {},
                  label: 'Log in',
                ),
              ),
            ),
            // Forgot password button
            TextOnlyButton(
              onPressed: () {},
              label: 'Forgot password?',
            ),
            // Register page button
            TextOnlyButton(
              onPressed: () {},
              label: 'Don\'t have an account? Register here.',
            )
          ],
        ),
      ),
    );
  }
}
