import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final uId = AuthService.firebase().currentUser?.id;
                return const Text('DONE');
              default:
                return const Text('LOADING.....');
            }
          }),
    );
  }
}
