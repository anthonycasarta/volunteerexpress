import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_user_roles_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';

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
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
              ];
            },
            onSelected: (value) async {
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
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
            },
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextOnlyButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, eventPageRoute),
                      label: "Event Form"),
                  TextOnlyButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, profileRoute),
                      label: "Profile Page"),
                  TextOnlyButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, volunteerHistoryRoute),
                      label: "Volunteer History"),
                  TextOnlyButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, notificationRoute),
                      label: "Notifications"),
                  TextOnlyButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, matchingFormRoute),
                      label: "Matching Form"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
