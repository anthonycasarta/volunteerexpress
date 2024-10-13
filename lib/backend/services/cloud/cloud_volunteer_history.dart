import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';

class CloudVolunteerHistory {
  final String docId;
  final String ownerUid;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final String eventSkills;
  final String eventUrgency;
  final String eventDate;

  @immutable
  CloudVolunteerHistory({
    required this.docId,
    required this.ownerUid,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventSkills,
    required this.eventUrgency,
    required this.eventDate,
  });

  // Firestore
  CloudVolunteerHistory.fromSnapshot(
      firestore.QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        ownerUid = snapshot.data()[ownerUidFieldName],
        eventName = snapshot.data()[eventNameFieldName],
        eventDescription = snapshot.data()[eventDescriptionFieldName],
        eventLocation = snapshot.data()[eventLocationFieldName],
        eventSkills = snapshot.data()[eventSkillsFieldName],
        eventUrgency = snapshot.data()[eventUrgencyFieldName],
        eventDate = snapshot.data()[eventDateFieldName];
}
