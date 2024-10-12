import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:volunteerexpress/backend/services/notification_services.dart';

@GenerateMocks([NotificationServices])
import 'notification_services_test.mocks.dart';

void main() {
  late MockNotificationServices mockNotificationService;

  setUp(() {
    mockNotificationService = MockNotificationServices();
  });

  group('NotificationService Tests', () {
    test('should return a list of notifications', () async {
      final mockNotifications = [
        {
          'title': 'You have an event tomorrow',
          'description': 'Food Packaging begins tomorrow from 2PM-4PM',
          'time': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'title': 'New Event Available',
          'description': 'Food Drive event is now available!',
          'time': DateTime.now().subtract(const Duration(days: 1)),
        },
      ];

      when(mockNotificationService.fetchNotifications())
          .thenAnswer((_) async => mockNotifications);

      final result = await mockNotificationService.fetchNotifications();

      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result[0]['title'], 'You have an event tomorrow');
      expect(result[1]['description'], 'Food Drive event is now available!');
    });

    test('should return an empty list when no notifications are available',
        () async {
      when(mockNotificationService.fetchNotifications())
          .thenAnswer((_) async => []);

      final result = await mockNotificationService.fetchNotifications();

      expect(result, isEmpty);
    });

    test('should return notifications with correct data types', () async {
      final mockNotifications = [
        {
          'title': 'A String containing Title',
          'description': 'A String containing Description',
          'time': DateTime.now(),
        }
      ];

      when(mockNotificationService.fetchNotifications())
          .thenAnswer((_) async => mockNotifications);

      final result = await mockNotificationService.fetchNotifications();

      expect(result[0]['title'], isA<String>());
      expect(result[0]['description'], isA<String>());
      expect(result[0]['time'], isA<DateTime>());
    });
  });
}
