import 'package:flutter/material.dart';
import 'package:volunteerexpress/themes/colors.dart';
import 'package:volunteerexpress/services/notification_services.dart';

class NotificationViewPage extends StatefulWidget {
  const NotificationViewPage({super.key});

  @override
  State<NotificationViewPage> createState() => _NotificationViewPageState();
}

class _NotificationViewPageState extends State<NotificationViewPage> {
  NotificationServices _notificationServices = NotificationServices();
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState(){
    super.initState();
    _notificationsFuture = _notificationServices.fetchNotifications();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }

          final notifications = snapshot.data!;
          return ListView.separated(
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return listViewItem(notification);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 0);
            },
            itemCount: notifications.length,
          );
        },
      ),
    );
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
    );
  }

  Widget listViewItem(Map<String, dynamic> notification) {
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
                  message(notification['title'], notification['description']),
                  timeAndDate(notification['time']),
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

  Widget message(String title, String description) {
    double textSize = 14;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '$title ',
        style: TextStyle(
            fontSize: textSize,
            color: Colors.black,
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: description,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget timeAndDate(DateTime time) {
    String formattedDate = '${time.month}-${time.day}-${time.year}';
    String formattedTime = '${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? "PM" : "AM"}';
    
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            formattedTime,
            style: const TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}
