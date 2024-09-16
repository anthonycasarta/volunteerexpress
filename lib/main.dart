import 'package:flutter/material.dart';
import 'package:volunteerexpress/themes/colors.dart';
import 'profile.dart';
import 'event_form.dart';
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
        textTheme: const TextTheme(
          // Textfield input text
          bodyLarge: TextStyle(
            fontSize: 20,
            color: textColorDark,
          ),
          // Textfield hint text
          titleMedium: TextStyle(
            fontSize: 20,
            color: textColorDark,
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
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: textColorDark,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryAccentColor,
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryAccentColor),
        useMaterial3: true,
      ),
      home: EventManagementForm(),
    );
  }
}
