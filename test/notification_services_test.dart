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
    test('should return a list of notifications', () async {
      await fakeFirestore.collection('notifications').add({
        'title': 'Event Tomorrow',
        'description': 'Event at 2PM tomorrow.',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1))),
      });
      await fakeFirestore.collection('notifications').add({
        'title': 'New Event Available',
        'description': 'New Event available now!',
        'time': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      });

      final result = await notificationService.fetchNotifications();

      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result[0]['title'], 'Event Tomorrow');
      expect(result[1]['description'], 'New Event available now!');
    });

    test('should return an empty list when no notifications are available', () async {
      final result = await notificationService.fetchNotifications();

      expect(result, isEmpty);
    });

    test('should add a notification to Firestore', () async {
      DateTime now = DateTime(2024, 10, 10, 17, 30);

      await notificationService.addNotification(
        'New Event',
        'A new event has been added',
        now,
      );

      final snapshot = await fakeFirestore.collection('notifications').get();
      final notifications = snapshot.docs.map((doc) => doc.data()).toList();

      expect(notifications.length, 1);
      expect(notifications[0]['title'], 'New Event');
      expect(notifications[0]['description'], 'A new event has been added');
      expect((notifications[0]['time'] as Timestamp).toDate(), now);
    });
  });
}
