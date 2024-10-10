import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  //final FirebaseFirestore firestore;

  //NotificationServices({required this.firestore});

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        'title': 'Event Reminder',
        'description': 'Don\'t forget about the event tomorrow at 10 AM!',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'title': 'New Event Assigned',
        'description': 'You have been assigned to Food Packaging. Please confirm your availability.',
        'time': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'title': 'Event Update',
        'description': 'The start time for Food Packaging has changed to 2 PM.',
        'time': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];
  }
}
