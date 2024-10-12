import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/forms/login_form.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Text Controllers
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Spacing
                const SizedBox(height: 125),

                // Register Volunteer heading
                const ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: primaryAccentColor,
                      width: 3.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),

                  // Heading color
                  tileColor: fadedPrimaryColorSaturated,
                  title: Text(
                    'Account Log in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Login form
                LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formKey: _loginFormKey,
                ),

                // Spacing
                const SizedBox(height: 20),

                // Button to go to Register page
                TextOnlyButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  label: 'Don\'t have an account? Register here.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
