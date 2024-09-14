import 'package:flutter/material.dart';
import 'package:volunteerexpress/constants/routes.dart';
import 'package:volunteerexpress/custom-widgets/forms/register_form.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/enums/auth_enums.dart';
import 'package:volunteerexpress/themes/colors.dart';

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

              // Register Volunteer heading
              ListTile(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: primaryAccentColor,
                    width: 3.5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),

                // Heading color
                tileColor: _auth == Auth.volunteer
                    ? fadedPrimaryColorSaturated
                    : unfocusedSecondaryAccentColor,
                title: Text(
                  'Register Volunteer Account',
                  style: TextStyle(
                    color: _auth == Auth.volunteer
                        ? textColorLight
                        : textColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Leading button
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

              // Spacing
              const SizedBox(height: 0.5),

              // Volunteer registration form
              if (_auth == Auth.volunteer)
                RegisterForm(
                  formKey: _volunteerFormKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),

              // Spacing
              const SizedBox(height: 8),

              // Register Admin heading
              ListTile(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: primaryAccentColor,
                    width: 3.5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),

                // Heading color
                tileColor: _auth == Auth.admin
                    ? fadedPrimaryColorSaturated
                    : unfocusedSecondaryAccentColor,
                title: Text(
                  'Register Admin Account',
                  style: TextStyle(
                    color: _auth == Auth.admin ? textColorLight : textColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Leading button
                leading: Radio(
                  activeColor: primaryAccentColor,
                  value: Auth.admin,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
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
                ),

              // Spacing
              const SizedBox(height: 50),

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
    ));
  }
}
