import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/notification_services.dart';

void main() {
  late NotificationServices notificationService;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    notificationService = NotificationServices(firestore: fakeFirestore);
  });

  group('NotificationService Tests', () {
    test('fetchNotificationsForUser should return user-specific and global notifications', () async {
      // Add global notifications
      await fakeFirestore.collection('NOTIFICATION').add({
        'title': 'Global Event',
        'description': 'This event is for everyone.',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'is_global': true,
        'user_id': null,
      });

      // Add user-specific notifications
      await fakeFirestore.collection('NOTIFICATION').add({
        'title': 'User Event',
        'description': 'This event is just for you.',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        'is_global': false,
        'user_id': 'user123',
      });

      final result = await notificationService.fetchNotificationsForUser('user123');

      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result.any((notif) => notif['title'] == 'Global Event'), true);
      expect(result.any((notif) => notif['title'] == 'User Event'), true);
    });

    test('fetchNotificationsForUser should return only global notifications for other users', () async {
      // Add global notifications
      await fakeFirestore.collection('NOTIFICATION').add({
        'title': 'Global Event',
        'description': 'This event is for everyone.',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'is_global': true,
        'user_id': null,
      });

      // Add user-specific notifications
      await fakeFirestore.collection('NOTIFICATION').add({
        'title': 'User Event',
        'description': 'This event is just for a specific user.',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        'is_global': false,
        'user_id': 'user123',
      });

      final result = await notificationService.fetchNotificationsForUser('user456');

      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result[0]['title'], 'Global Event');
    });

    test('fetchNotificationsForUser should return an empty list for unauthenticated users', () async {
      final result = await notificationService.fetchNotificationsForUser(null);

      expect(result, isEmpty);
    });

    test('should add a notification to Firestore', () async {
      DateTime now = DateTime(2024, 10, 10, 17, 30);

      await notificationService.addNotification(
        'New Event',
        'A new event has been added',
        now,
        false,
        'user12345',
      );

      final snapshot = await fakeFirestore.collection('NOTIFICATION').get();
      final notifications = snapshot.docs.map((doc) => doc.data()).toList();

      expect(notifications.length, 1);
      expect(notifications[0]['title'], 'New Event');
      expect(notifications[0]['description'], 'A new event has been added');
      expect((notifications[0]['time'] as Timestamp).toDate(), now);
      expect(notifications[0]['is_global'], false);
      expect(notifications[0]['user_id'], 'user12345');
    });
  });
}
