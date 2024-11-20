import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_user_roles_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/pages/report_page.dart';
import 'package:volunteerexpress/frontend/pages/user-home-pages/admin_home_page.dart';
import 'package:volunteerexpress/frontend/pages/user-home-pages/volunteer_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseUserRolesService _userRolesService;
  final uId = AuthService.firebase().currentUser?.id;

  @override
  void initState() {
    _userRolesService = FirebaseUserRolesService();
    super.initState();
  }

  void fetchRole() async {
    //userRole = await _userRolesService.getRole(userId: uId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: _userRolesService.getRole(userId: uId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final userRole = snapshot.data!;
                  if (userRole == 'admin') {
                    return const AdminHomePage();
                  } else if (userRole == 'volunteer') {
                    return const VolunteerHomePage();
                  }
                  return const Text('DONE');
                default:
                  return const Text('LOADING.....');
              }
            },
          ),
          // Center(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         TextOnlyButton(
          //             onPressed: () =>
          //                 Navigator.pushNamed(context, eventPageRoute),
          //             label: "Event Form"),
          //         TextOnlyButton(
          //             onPressed: () => Navigator.pushNamed(context, profileRoute),
          //             label: "Profile Page"),
          //         TextOnlyButton(
          //             onPressed: () =>
          //                 Navigator.pushNamed(context, volunteerHistoryRoute),
          //             label: "Volunteer History"),
          //         TextOnlyButton(
          //             onPressed: () =>
          //                 Navigator.pushNamed(context, notificationRoute),
          //             label: "Notifications"),
          //         TextOnlyButton(
          //             onPressed: () =>
          //                 Navigator.pushNamed(context, matchingFormRoute),
          //             label: "Matching Form"),
          //         TextOnlyButton(
          //             onPressed: () =>
          //                 Navigator.pushNamed(context, reportPageRoute),
          //             label: "Report Page"),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
