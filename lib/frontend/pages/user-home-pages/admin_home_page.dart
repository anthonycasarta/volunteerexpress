import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Add more admin-specific buttons here
          ],
        ),
      ),
    );
  }
}
