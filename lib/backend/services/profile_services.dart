import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    firestore.collection('PROFILE').add({
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
}
