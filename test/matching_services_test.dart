import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';

void main() {
  test('Matching Services displays matched volunteers correctly', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('PROFILE').add({
      'fullName': 'Zachary Pierce',
      'preference': 'Delivery Driving',
      'dates': ['2024-10-13T00:00:00.000Z'],//ISO8601 date string in case anyone is wondering
    });
    await fakeFirestore.collection('PROFILE').add({
      'fullName': 'Tom Brady',
      'preference': 'Hands-on work',
      'dates': ['2024-10-14T00:00:00.000Z'], //Different date
    });

    final matchingServices = MatchingServices(firestore: fakeFirestore);
    List<Map<String, dynamic>> matchedVolunteers =
        await matchingServices.displayMatchedVolunteers('2024-10-13T00:00:00.000Z');

    expect(matchedVolunteers.length, 1);
    expect(matchedVolunteers.first['fullName'], 'Zachary Pierce');
  });
}
