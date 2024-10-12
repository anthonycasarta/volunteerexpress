import 'package:flutter/material.dart';
import 'package:volunteerexpress/constants/routes.dart';
import 'package:volunteerexpress/pages/matching_form.dart';
import 'package:volunteerexpress/pages/auth-pages/login_page.dart';
import 'package:volunteerexpress/pages/auth-pages/register_page.dart';

import 'package:volunteerexpress/pages/notifications.dart';
import 'package:volunteerexpress/pages/profile.dart';
import 'package:volunteerexpress/pages/volunteer_history.dart';
import 'package:volunteerexpress/themes/colors.dart';

import 'package:volunteerexpress/pages/event_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart'; // Import EventBloc
import 'package:volunteerexpress/backend/eventPage/event_repository.dart'; // Import your EventRepository
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // removes debug banner
      theme: ThemeData(
        scaffoldBackgroundColor: majorColorLightMode,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryAccentColor,
          titleTextStyle: TextStyle(
            color: textColorLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // icon button color
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStatePropertyAll<Color>(
              textColorLight,
            ),
          ),
        ),
        textTheme: const TextTheme(
          // Textfield input text
          bodyLarge: TextStyle(
            fontSize: 20,
            color: textColorDark,
          ),
          // Textfield hint text
          titleMedium: TextStyle(
            fontSize: 20,
          ),
          displaySmall: TextStyle(
            fontSize: 20,
            color: textColorDark,
          ),
          displayMedium: TextStyle(
            fontSize: 25,
            color: textColorDark,
          ),
          displayLarge: TextStyle(
            fontSize: 35,
            color: textColorDark,
          ),
        ),
        // Textfield theme
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: subtleTextColorDark,
            fontWeight: FontWeight.normal,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          // Textfield error theme
          errorStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: errorColor,
          ),
          // Textfield error border theme
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: errorColor,
              width: 2,
            ),
          ),
          // Textfield border theme
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: textColorDark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryAccentColor,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryAccentColor),
        useMaterial3: true,
      ),

      home: const LoginPage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        profileRoute: (context) => const ProfilePage(),
        notificationRoute: (context) => const NotificationViewPage(),
        volunteerHistoryRoute: (conttext) => const VolunteerHistoryPage(),
        eventPageRoute: (context) => BlocProvider(
          create: (context) => EventBloc(EventRepository(firestore: FakeFirebaseFirestore())), // Initialize EventBloc
          child: const EventPage(),
        ),
        matchingFormRoute: (context) => const MatchingFormPage(),
      },
    );
  }
}
