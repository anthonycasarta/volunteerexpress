import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';

void main() {
  test('Matching Services displays matched volunteers correctly', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('PROFILE').add({
      'fullName': 'Zachary Pierce',
      'skills': ['Delivery Driving'],
      'dates': ['2024-10-13T00:00:00.000Z'],//ISO8601 date string in case anyone is wondering
    });
    await fakeFirestore.collection('PROFILE').add({
      'fullName': 'Tom Brady',
      'skills': ['Hands-on work'],
      'dates': ['2024-10-14T00:00:00.000Z'], //Different date
    });

    final matchingServices = MatchingServices(firestore: fakeFirestore);
    List<Map<String, dynamic>> matchedVolunteers =
        await matchingServices.displayMatchedVolunteers('2024-10-13T00:00:00.000Z',['Delivery Driving']);

    expect(matchedVolunteers.length, 1);
    expect(matchedVolunteers.first['fullName'], 'Zachary Pierce');
  });


  test('Add to volunteer history works correctly', () async{
    final FakeFirestore = FakeFirebaseFirestore();
    final matchingServices = MatchingServices(firestore: FakeFirestore);
    await matchingServices.addToVolunteerHistory("123","123","Assigned");
    final snapshot = await FakeFirestore.collection('volunteer_history').get();
    
    expect(snapshot.docs.length, 1);
    final snap = snapshot.docs.first;
    expect(snap.get('event_id'), '123');
    expect(snap.get('vol_id'), '123');
    expect(snap.get('vol_status'), 'Assigned');
  });
}

