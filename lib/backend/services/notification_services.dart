import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  final FirebaseFirestore firestore;

  NotificationServices({required this.firestore});
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
      QuerySnapshot querySnapshot = await firestore.collection('NOTIFICATION').get();

      List<Map<String, dynamic>> notifications = querySnapshot.docs.map((doc) {
        return {
          'title': doc['title'],
          'description': doc['description'],
          'time': doc['time'].toDate(),
        };
      }).toList();

      return notifications;
  }

  Future<void> addNotification(String title, String description, DateTime time) async {
      await firestore.collection('NOTIFICATION').add({
        'title': title,
        'description': description,
        'time': Timestamp.fromDate(time),
      });
  }
}
