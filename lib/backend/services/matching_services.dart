import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingServices {
  final FirebaseFirestore firestore;

  MatchingServices({required this.firestore});

  Future<List<Map<String, dynamic>>> displayMatchedVolunteers(String targetDate, List<String> skills) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('PROFILE')
          .where('dates', arrayContains: targetDate)
          .get();

      // Filter for volunteers who have at least one skill from the `skills` list
      List<Map<String, dynamic>> matchedVolunteers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((volunteer) {
            List<dynamic> volunteerSkills = volunteer['skills'] ?? [];
            return skills.any((skill) => volunteerSkills.contains(skill));
          })
          .toList();

      return matchedVolunteers;
    } catch (e) {
      print('Error in matching volunteers: $e');
      return [];
    }
  }

  Future<void> addToVolunteerHistory(
    String eventId,
    String volunteerId,
    String userId,
  ) async {
    try{
      await firestore.collection('volunteer_history').add({
        'event_id': eventId,
        'vol_id': volunteerId,
        'vol_status': 'Assigned',

      });
    } catch (e) {
      print("Error adding to volunteer history");
    }
  }
}