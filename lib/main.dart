import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/pages/home_page.dart';

import 'package:volunteerexpress/frontend/pages/matching_form.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/login_page.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/register_page.dart';
import 'package:volunteerexpress/frontend/pages/notifications.dart';
import 'package:volunteerexpress/frontend/pages/profile.dart';
import 'package:volunteerexpress/frontend/pages/volunteer-history/volunteer_history.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/frontend/pages/event_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:volunteerexpress/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make sure the function is async so you can use await
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  runApp(MyApp(firestore: firestore));
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore firestore;

  const MyApp({super.key, required this.firestore});

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

      home: const Routes(),
      routes: {
        homePageRoute: (context) => const HomePage(),
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        profileRoute: (context) => const ProfilePage(),
        notificationRoute: (context) => const NotificationViewPage(),
        volunteerHistoryRoute: (context) => const VolunteerHistoryPage(),
        eventPageRoute: (context) => BlocProvider(
              create: (context) => EventBloc(EventRepository(
                  firestore: firestore)), // Initialize EventBloc
              child: const EventPage(),
            ),
        matchingFormRoute: (context) => const MatchingFormPage(),
      },
    );
  }
}

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }

              default:
                return const Text('LOADING.....');
            }
          }),
    );
  }
}
