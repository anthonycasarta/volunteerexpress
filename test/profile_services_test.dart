import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/services/profile_services.dart';

void main() {
  testWidgets('Test profile data is saved to Firestore', (WidgetTester tester) async {
    final instance = FakeFirebaseFirestore();
   
    String fullName = 'Zachary Pierce';
    String address = '9813 Hyacinth Way';
    String city = 'Conroe';
    String state = 'TX';
    String zipCode = '77385';
    String preference = 'Delivery Driving';
    List<DateTime> dates = [DateTime.now()];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
           
            ProfileServices().saveProfileToFirestore(
              fullName, address, city, state, zipCode, preference, dates, context, instance
            );
            return Container();
          },
        ),
      ),
    );

    final snapshot = await instance.collection('profiles').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.get('fullName'), 'Zachary Pierce');
    expect(snapshot.docs.first.get('address'), '9813 Hyacinth Way');
    expect(snapshot.docs.first.get('city'), 'Conroe');
    expect(snapshot.docs.first.get('state'), 'TX');
    expect(snapshot.docs.first.get('zipCode'), '77385');
    expect(snapshot.docs.first.get('preference'), 'Delivery Driving');
    
  });
}
