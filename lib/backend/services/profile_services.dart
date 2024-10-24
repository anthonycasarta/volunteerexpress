import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileServices {
  final FirebaseFirestore firestore;

  // Constructor accepts an instance of FirebaseFirestore
  ProfileServices({required this.firestore});
  Future<void> saveProfileToFirestore(
      String fullName,
      String address,
      String city,
      String state,
      String zipCode,
      String preference,
      List<DateTime> dates) async {
    // try {

    await firestore.collection('profiles').add({
      'fullName': fullName,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'preference': preference,
      'dates': dates.map((date) => date.toIso8601String()).toList(),
    });
  }
}
