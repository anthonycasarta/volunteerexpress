import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/profile_services.dart';

void main() {
  test('ProfileServices saves profile correctly to Firestore', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    final profileService = ProfileServices(firestore: fakeFirestore);
    List<DateTime> dates = [DateTime(2024, 10, 7)];

    await profileService.saveProfileToFirestore(
        'Zachary Pierce',
        '9813 Hyacinth Way',
        'Conroe',
        'TX',
        '77385',
        ['Delivery Driving'],
        dates);

    final snapshot = await fakeFirestore.collection('PROFILE').get();
    expect(snapshot.docs.length, 1); // Ensure one document is added

    final profile = snapshot.docs.first;
    expect(profile.get('fullName'), 'Zachary Pierce');
    expect(profile.get('address'), '9813 Hyacinth Way');
    expect(profile.get('city'), 'Conroe');
    expect(profile.get('state'), 'TX');
    expect(profile.get('zipCode'), '77385');
    expect(profile.get('skills'), ['Delivery Driving']);
    expect(profile.get('dates'), [dates.first.toIso8601String()]);
  });
}
