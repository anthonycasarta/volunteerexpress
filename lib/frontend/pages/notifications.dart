import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/backend/services/notification_services.dart';
import 'package:volunteerexpress/frontend/pages/notification_details.dart';

class NotificationViewPage extends StatefulWidget {
  const NotificationViewPage({super.key});

  @override
  State<NotificationViewPage> createState() => _NotificationViewPageState();
}

class _NotificationViewPageState extends State<NotificationViewPage> {
  final NotificationServices notificationServices =
      NotificationServices(firestore: FirebaseFirestore.instance);
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final fetchedNotifications =
        await notificationServices.fetchNotificationsForUser(userID);

    setState(() {
      notifications = fetchedNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return listView();
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: const Text('Notifications'),
      backgroundColor: primaryAccentColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
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
    );
  }

  Widget listView() {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications available'),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) {
          return listViewItem(index);
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
        itemCount: notifications.length);
  }

  Widget listViewItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  timeAndDate(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: primaryAccentColor,
      ),
      child: const Icon(
        Icons.notifications,
        size: 25,
        color: Colors.white,
      ),
    );
  }

  Widget message(index) {
    double textSize = 14;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: notifications[index]['title'] ?? 'No title',
        style: TextStyle(
            fontSize: textSize,
            color: Colors.black,
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: ' ${notifications[index]['description'] ?? 'No description'}',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget timeAndDate(int index) {
    DateTime dateTime = notifications[index]['time'];
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${dateTime.month}-${dateTime.day}-${dateTime.year}',
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            '${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'pm' : 'am'}',
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetailPage(
                    title: notifications[index]['title'],
                    description: notifications[index]['description'],
                    dateTime: notifications[index]['time'],
                  ),
                ),
              );
            },
            child: const Text(
              'Open',
              style: TextStyle(
                color: primaryAccentColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
