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
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 15,
              ),
              child: SizedBox(
                width: 250,
                child: DefaultTextButton(
                  onPressed: () {},
                  label: 'Log in',
                ),
              ),
            ),
            TextOnlyButton(
              onPressed: () {},
              label: 'Already have an account? Register here.',
            )
          ],
        ),
      ),
    );
  }
}
