import 'package:cloud_firestore/cloud_firestore.dart';


class MatchingServices {
  final FirebaseFirestore firestore;

  MatchingServices({required this.firestore});
  Future<List<Map<String, dynamic>>> displayMatchedVolunteers(String targetDate) async{//, String targetDate ) async {
    QuerySnapshot querySnapshot = await firestore.collection('PROFILE')
    //.where('skills', isEqualTo: skill)
    .where('dates', arrayContains: targetDate)
    .get();

    List<Map<String, dynamic>> matchedVolunteers = querySnapshot.docs
    .map((doc)=>doc.data()as Map<String, dynamic>)
    .toList();
    return matchedVolunteers;
  }
}