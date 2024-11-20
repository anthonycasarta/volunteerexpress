import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';

class VolunteerHomePage extends StatelessWidget {
  const VolunteerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Volunteer!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Add more volunteer-specific buttons here
          ],
        ),
      ),
    );
  }
}
