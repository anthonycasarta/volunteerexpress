import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/sidebar.dart';
import 'package:volunteerexpress/frontend/pages/home_page.dart';

import 'package:volunteerexpress/frontend/pages/matching_form.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/login_page.dart';
import 'package:volunteerexpress/frontend/pages/auth-pages/register_page.dart';
import 'package:volunteerexpress/frontend/pages/notifications.dart';
import 'package:volunteerexpress/frontend/pages/profile.dart';
import 'package:volunteerexpress/frontend/pages/volunteer-history/volunteer_history_page.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/frontend/pages/event_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:volunteerexpress/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/frontend/pages/report_page.dart';

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
        homePageRoute: (context) => const Sidebar(
              title: 'H O M E',
              child: HomePage(),
            ),
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        profileRoute: (context) => const Sidebar(
              title: 'P R O F I L E',
              child: ProfilePage(),
            ),
        notificationRoute: (context) => const Sidebar(
              title: 'N O T I F I C A T I O N S',
              child: NotificationViewPage(),
            ),
        volunteerHistoryRoute: (context) => const Sidebar(
              title: 'V O L U N T E E R   H I S T O R Y',
              child: VolunteerHistoryPage(),
            ),
        eventPageRoute: (context) => BlocProvider(
              create: (context) => EventBloc(EventRepository(
                  firestore: firestore)), // Initialize EventBloc
              child: const Sidebar(
                title: 'E V E N T S',
                child: EventPage(),
              ),
            ),
        matchingFormRoute: (context) => const Sidebar(
              title: 'M A T C H I N G  F O R M',
              child: MatchingFormPage(),
            ),
        reportPageRoute: (context) => const Sidebar(
              title: 'R E P O R T',
              child: ReportPage(),
            ),
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
                  return const Sidebar(title: 'H O M E', child: HomePage());
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
