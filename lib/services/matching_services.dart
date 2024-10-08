import 'package:cloud_firestore/cloud_firestore.dart';


class MatchingServices {
  final FirebaseFirestore firestore;

  MatchingServices({required this.firestore});
  Future<List<Map<String, dynamic>>> displayMatchedVolunteers(String userpreference) async {
    QuerySnapshot querySnapshot = await firestore.collection('profiles')
    .where('preference',isEqualTo: userpreference)
    .get();

    List<Map<String, dynamic>> matchedVolunteers = querySnapshot.docs
    .map((doc)=>doc.data()as Map<String, dynamic>)
    .toList();
    return matchedVolunteers;
  }
}