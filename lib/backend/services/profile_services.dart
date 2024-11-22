import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteerexpress/models/profile_model.dart';



class ProfileServices {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  // Constructor accepts an instance of FirebaseFirestore
  
  ProfileServices({required this.firestore,required this.auth});
  
  
  Future<void> saveProfileToFirestore (
      String fullName,
      String address,
      String city,
      String state,
      String zipCode,
      List<String> selectedSkills,
      List<DateTime> dates) async {
    // try {
      User? currentUser = auth.currentUser;
      if (currentUser == null) {
      throw Exception("No user is logged in.");
    }
    String userId = currentUser.uid; // Retrieve the user's UID

    await firestore.collection('PROFILE').add({
      'fullName': fullName,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'skills': selectedSkills,
      'dates': dates.map((date) => date.toIso8601String()).toList(),
      'userId': userId,
    });

  }


  Future<Profile> fetchProfileInfo() async {
      User? currentUser = auth.currentUser;
      if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

      String userId = currentUser.uid;

      final docRef = await firestore.collection("PROFILE")
        .where('userId', isEqualTo: userId)
        .get();
        
        if (docRef.docs.isNotEmpty) {

          final docProfile = docRef.docs.first;
          return (Profile(
            fullName: docProfile['fullName'],
            address: docProfile['address'],
            city: docProfile['city'],
            state: docProfile['state'],
            zipCode: docProfile['zipCode'],
            selectedSkills: (docProfile['skills'] as List<dynamic>).cast<String>(),
            dates: (docProfile['dates'] as List<dynamic>).cast<String>(),
            userID: userId,
          ));
        } else {
          
          return (Profile(
            fullName: 'No Profile',
            address: 'No Profile',
            city: 'No Profile',
            state: 'No Profile',
            zipCode: 'No Profile',
            selectedSkills: ['No Profile'],
            dates:['No Profile'],
            userID: 'No Profile',
          ));
        }

    }

  /* Made fetching the Profile Info too slow, having to go to the firebase twice for one request
    Future<bool> profileInDatabase() async {
      User? currentUser = auth.currentUser;
      if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

      String userId = currentUser.uid;

      final docRef = await firestore.collection("PROFILE")
        .where('userId', isEqualTo: userId)
        .get();


      return (docRef.docs.isNotEmpty);

    }

    */

  Future<void> updateProfile(Profile upProfile) async {
    User? currentUser = auth.currentUser;
      if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

      String userId = currentUser.uid;

      final docRef = await firestore.collection("PROFILE")
        .where('userId', isEqualTo: userId)
        .get()
        .then((value) => value.docs.first.reference);

      await docRef.update({
        'fullName': upProfile.fullName,
        'address': upProfile.address,
        'city': upProfile.city,
        'state': upProfile.state,
        'zipCode': upProfile.zipCode,
        'skills': upProfile.selectedSkills,
        'dates': upProfile.dates,
        'userId': userId,
      });






  }



}
