import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_user_roles_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/pages/home_page.dart';
import 'package:volunteerexpress/frontend/pages/matching_form.dart';
import 'package:volunteerexpress/frontend/pages/notifications.dart';
import 'package:volunteerexpress/frontend/pages/profile.dart';
import 'package:volunteerexpress/frontend/pages/report_page.dart';
import 'package:volunteerexpress/frontend/pages/volunteer-history/volunteer_history_page.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class Sidebar extends StatelessWidget {
  final Widget child;
  final String title;

  const Sidebar({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    final FirebaseUserRolesService _userRolesService =
        FirebaseUserRolesService();
    final String? uId = AuthService.firebase().currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
      drawer: Drawer(
        child: FutureBuilder<String>(
          future: _userRolesService.getRole(userId: uId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final String? userRole = snapshot.data;
              if (userRole == null) {
                return const Center(
                  child: Text(
                    "Role not found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              // Build the sidebar based on the user role
              return Container(
                color: primaryAccentColor,
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        // Common
                        ListTile(
                          leading: const Icon(Icons.home, color: Colors.white),
                          title: const Text('Home',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, homePageRoute);
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.white),
                          title: const Text('Profile',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, profileRoute);
                          },
                        ),
                        if (userRole == 'admin') ...[
                          ListTile(
                            leading:
                                const Icon(Icons.report, color: Colors.white),
                            title: const Text('Report',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pushNamed(context, reportPageRoute);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.handshake,
                                color: Colors.white),
                            title: const Text('Matching Form',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pushNamed(context, matchingFormRoute);
                            },
                          ),
                        ] else if (userRole == 'volunteer') ...[
                          ListTile(
                            leading:
                                const Icon(Icons.history, color: Colors.white),
                            title: const Text('Volunteer History',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, volunteerHistoryRoute);
                            },
                          ),
                        ],
                        ListTile(
                          leading: const Icon(Icons.notifications,
                              color: Colors.white),
                          title: const Text('Notifications',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, notificationRoute);
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.logout, color: Colors.white),
                          title: const Text('Log out',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            await AuthService.firebase().logOut();
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute,
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    // Close Arrow on Top Right
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context); // Closes the drawer
                        },
                        icon: const Icon(
                          Icons.chevron_left, // Chevron icon
                          color: Colors.white,
                          size: 28, // Customize the size
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Unknown state"));
          },
        ),
      ),
      body: child,
    );
  }
}
