import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';

class CloudVolunteerHistory {
  final String docId;
  final String volunteerUid;
  final String eventId;
  final String volunteerStatus;

  @immutable
  CloudVolunteerHistory({
    required this.docId,
    required this.volunteerUid,
    required this.eventId,
    required this.volunteerStatus,
  });

  // Firestore
  CloudVolunteerHistory.fromSnapshot(
      firestore.QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        volunteerUid = snapshot.data()[volunteerUidFieldName],
        eventId = snapshot.data()[eventIdFieldName],
        volunteerStatus = snapshot.data()[volunteerStatusFieldName];
}
