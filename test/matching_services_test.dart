import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';

void main() {
  test('Matching Services displays matched volunteers correctly', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('profiles').add({
      'fullName': 'Zachary Pierce',
      'preference': 'Delivery Driving',
    });
    await fakeFirestore.collection('profiles').add({
      'fullName': 'Tom Brady',
      'preference': 'Hands-on work',
    });

    final matchingServices = MatchingServices(firestore: fakeFirestore);
    List<Map<String, dynamic>> matchedVolunteers =
        await matchingServices.displayMatchedVolunteers('Delivery Driving');

    expect(matchedVolunteers.length, 1);
    expect(matchedVolunteers.first['fullName'], 'Zachary Pierce');
  });
}
