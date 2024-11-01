import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_user_roles_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseUserRolesService _userRolesService;
  final uId = AuthService.firebase().currentUser?.id;
  late final String userRole;

  @override
  void initState() {
    _userRolesService = FirebaseUserRolesService();
    super.initState();
  }

  void fetchRole() async {
    userRole = await _userRolesService.getRole(userId: uId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HOME'),
        ),
        body: FutureBuilder(
            future: _userRolesService.getRole(userId: uId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  userRole = snapshot.data!;
                  if (userRole == 'admin') {
                    return const Text('ADMIN');
                  } else if (userRole == 'volunteer') {
                    return const Text('VOLUNTEER');
                  }
                  return const Text('DONE');
                default:
                  return const Text('LOADING.....');
              }
            }));
  }
}
