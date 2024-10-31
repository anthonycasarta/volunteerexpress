import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/forms/register_form.dart';
import 'package:volunteerexpress/frontend/custom-widgets/list-tile/form_list_tile.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/enums/auth_enums.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Auth _auth = Auth.volunteer;

  final _volunteerFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

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

  // Dispose text controllers
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
                const SizedBox(height: 50),

                // Register Volunteer tile
                FormListTile(
                  auth: _auth,
                  authValue: Auth.volunteer,
                  title: 'Register Volunteer Account',
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),

                // Spacing
                const SizedBox(height: 0.5),

                // Volunteer registration form
                if (_auth == Auth.volunteer)
                  RegisterForm(
                    formKey: _volunteerFormKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    role: 'volunteer',
                  ),

                // Spacing
                const SizedBox(height: 8),

                // Register Admin tile
                FormListTile(
                  auth: _auth,
                  authValue: Auth.admin,
                  title: 'Register Admin Account',
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),

                // Spacing
                const SizedBox(height: 0.7),

                // Manager Registration form
                if (_auth == Auth.admin)
                  RegisterForm(
                    formKey: _adminFormKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    role: 'admin',
                  ),

                // Spacing
                const SizedBox(height: 25),

                // Button to go to Log in page
                TextOnlyButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  label: 'Already have an account? Log in here.',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
