import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/backend/services/profile_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:volunteerexpress/models/profile_model.dart';

void main() {

  
  late ProfileServices profileServices;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth auth;
  late MockUser user;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();    
    
    user = MockUser(uid: '1234', email: 'testuser@example.com');
    auth = MockFirebaseAuth(mockUser: user, signedIn: true);

    /*
    await auth.signInWithEmailAndPassword(
      email: 'testuser@example.com', 
      password: 'password123',
    );
    */

    profileServices = ProfileServices(firestore: fakeFirestore, auth: auth);
  });
  

  test('ProfileServices saves profile correctly to Firestore', () async {
    final profileServices = ProfileServices(firestore: fakeFirestore, auth: auth);
    
    List<DateTime> dates = [DateTime(2024, 10, 7)];

    await profileServices.saveProfileToFirestore(
        'Zachary Pierce',
        '9813 Hyacinth Way',
        'Conroe',
        'TX',
        '77385',
        ['Delivery Driving'],
        dates,
        );

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


  test('ProfileServices Fetch Test', () async {

      List<DateTime> dates = [DateTime(2024, 10, 7)];

      //print("User ID FROM TEST IS: ${user.uid}" );
      await fakeFirestore.collection('PROFILE').add({
        'fullName': 'Zachary Pierce',
        'address': '9813 Hyacinth Way',
        'city': 'Conroe',
        'state': 'TX',
        'zipCode': '77385',
        'skills': ['Delivery Driving'],
        'dates': dates.map((date) => date.toIso8601String()).toList(),
        'userId': user.uid,
      });

      final Profile fetchedProfile = await profileServices.fetchProfileInfo();
      
      expect(fetchedProfile.fullName, 'Zachary Pierce');
      expect(fetchedProfile.address, '9813 Hyacinth Way');
      expect(fetchedProfile.city, 'Conroe');
      expect(fetchedProfile.state, 'TX');
      expect(fetchedProfile.zipCode, '77385');
      expect(fetchedProfile.selectedSkills, ['Delivery Driving']);
      expect(fetchedProfile.dates, [dates.first.toIso8601String()]);
      expect(fetchedProfile.userID, user.uid);
  });


  
  test('ProfileServices Update Profile Test', () async {

      List<DateTime> dates = [DateTime(2024, 10, 7)];
      
      await fakeFirestore.collection('PROFILE').add({
        'fullName': 'Zachary Pierce',
        'address': '9813 Hyacinth Way',
        'city': 'Conroe',
        'state': 'TX',
        'zipCode': '77385',
        'skills': ['Delivery Driving'],
        'dates': dates.map((date) => date.toIso8601String()).toList(),
        'userId': user.uid,
      });


      final fetchProfile = Profile(
        fullName: "Name",
        address: "Address",
        city: 'city',
        state: 'state',
        zipCode: 'zip',
        selectedSkills: ['Adaptability'],
        dates: ['2024-10-10'],
        userID: user.uid,
      );

      await profileServices.updateProfile(fetchProfile);

      final snapshot = await fakeFirestore.collection("PROFILE").get();
      expect(snapshot.docs.length, 1); 

      final profile = snapshot.docs.first;
      
      expect(profile.get('fullName'), 'Name');
      expect(profile.get('address'), 'Address');
      expect(profile.get('city'), 'city');
      expect(profile.get('state'), 'state');
      expect(profile.get('zipCode'), 'zip');
      expect(profile.get('skills'), ['Adaptability']);
      expect(profile.get('dates'), ['2024-10-10']);
      expect(profile.get('userId'), user.uid);
  });

}
