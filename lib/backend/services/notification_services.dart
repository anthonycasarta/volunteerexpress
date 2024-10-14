import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  final FirebaseFirestore firestore;

  NotificationServices({required this.firestore});
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    //try {
      QuerySnapshot querySnapshot = await firestore.collection('notifications').get();

      List<Map<String, dynamic>> notifications = querySnapshot.docs.map((doc) {
        return {
          'title': doc['title'],
          'description': doc['description'],
          'time': doc['time'].toDate(),
        };
      }).toList();

      return notifications;
    //} catch (e) {
      //print('Error fetching notifications: $e');
      //return [];
    //}
  }

  Future<void> addNotification(String title, String description, DateTime time) async {
    //try {
      await firestore.collection('notifications').add({
        'title': title,
        'description': description,
        'time': Timestamp.fromDate(time),
      });
    //} catch (e) {
      //print('Error adding notification: $e');
    //}
  }
}
