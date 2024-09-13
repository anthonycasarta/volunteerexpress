import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/forms/register_form.dart';

import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';

import 'package:volunteerexpress/themes/colors.dart';

enum Auth {
  volunteer,
  manager,
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Auth _auth = Auth.volunteer;
  final _volunteerFormKey = GlobalKey<FormState>();
  final _managerFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              tileColor:
                  _auth == Auth.volunteer ? fadedColor : majorColorLightMode,
              title: const Text(
                'Create Volunteer Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // leading button
              leading: Radio(
                activeColor: primaryAccentColor,
                value: Auth.volunteer,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),

            // Volunteer registration form
            if (_auth == Auth.volunteer)
              RegisterForm(
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),

            ListTile(
              tileColor:
                  _auth == Auth.manager ? fadedColor : majorColorLightMode,
              title: const Text(
                'Create Manager Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // leading button
              leading: Radio(
                activeColor: primaryAccentColor,
                value: Auth.manager,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),

            // Manager Registration form
            if (_auth == Auth.manager)
              RegisterForm(
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),

            TextOnlyButton(
              onPressed: () {},
              label: 'Already have an account? Log in here.',
            )
          ],
        ),
      ),
    ));
  }
}
