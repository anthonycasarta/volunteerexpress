import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';


class ProfileServices {
 
  Future<void> saveProfileToFirestore(
    String fullName, String address, String city, String state, String zipCode, String preference, List<DateTime> dates, BuildContext context,
    FakeFirebaseFirestore firestoreInstance
  ) async {
   // try {
      
      await firestoreInstance.collection('profiles').add({
        'fullName': fullName,
        'address': address,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'preference': preference,
        'dates': dates.map((date) => date.toIso8601String()).toList(),
      });

      // Mocking successful data sending: Show a Snackbar if context is still mounted
      //if (context.mounted) {
        //ScaffoldMessenger.of(context).showSnackBar(
         // const SnackBar(content: Text('Profile saved to Firestore (Mock)')),
       // );
     // }
   // } catch (e) {
      // Handle any errors that occur during the mock Firestore data sending
     // if (context.mounted) {
       // ScaffoldMessenger.of(context).showSnackBar(
         // SnackBar(content: Text('Error saving profile: $e')),
       // );
     // }
    //}
  }
}
