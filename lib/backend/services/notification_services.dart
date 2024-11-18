import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  final FirebaseFirestore firestore;

  NotificationServices({required this.firestore});
  Future<List<Map<String, dynamic>>> fetchNotificationsForUser(String? userId) async {
    if (userId == null) return [];

    //global notifications.
    QuerySnapshot globalNotificationsQuery = await firestore
        .collection('NOTIFICATION')
        .where('is_global', isEqualTo: true)
        .get();

    //user-specific notifications.
    QuerySnapshot userNotificationsQuery = await firestore
        .collection('NOTIFICATION')
        .where('is_global', isEqualTo: false)
        .where('user_id', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> notifications = [
      ...globalNotificationsQuery.docs.map((doc) {
        return {
          'title': doc['title'],
          'description': doc['description'],
          'time': doc['time'].toDate(),
          'is_global': doc['is_global'],
          'user_id': doc['user_id'],
        };
      }),
      ...userNotificationsQuery.docs.map((doc) {
        return {
          'title': doc['title'],
          'description': doc['description'],
          'time': doc['time'].toDate(),
          'is_global': doc['is_global'],
          'user_id': doc['user_id'],
        };
      }),
    ];

    return notifications;
  }

  Future<void> addNotification(String title, String description, DateTime time, bool isGlobal, String userId) async {
      await firestore.collection('NOTIFICATION').add({
        'title': title,
        'description': description,
        'time': Timestamp.fromDate(time),
        'is_global': isGlobal,
        'user_id': userId,
      });
  }
}
