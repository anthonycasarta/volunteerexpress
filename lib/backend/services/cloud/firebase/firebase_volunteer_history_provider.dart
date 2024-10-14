import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_exceptions/cloud_volunteer_history_exceptions.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_cloud_storage.dart';

class FirebaseVolunteerHistoryService implements FirebaseCloudStorage {
  final FirebaseFirestore firestore;

  FirebaseVolunteerHistoryService({required this.firestore});
  // Variable containing the table/collection of volunteer history

  late final volunteerHistory = firestore.collection('volunteer_history');

  // Update the staus of a volunteer in an event
  Future<void> updateVolunteerStatus({
    required volunteerUid,
    required docId,
    required volunteerStatus,
  }) async {
    try {
      return await volunteerHistory.doc(docId).update({
        volunteerStatusFieldName: volunteerStatus,
      });
    } catch (e) {
      throw CouldNotUpdateVolunteerStatusException();
    }
  }

  // Associate a volunteer to an event
  Future<CloudVolunteerHistory> addToVolunteerHistory({
    required volunteerUid,
    required eventId,
  }) async {
    final historyItem = await volunteerHistory.add({
      volunteerUidFieldName: volunteerUid,
      eventIdFieldName: eventId,
      volunteerStatusFieldName: 'Assigned',
    });

    // Get the added history
    final fetchedHistoryItem = await historyItem.get();

    // Return cloud volunteer history
    return CloudVolunteerHistory(
        docId: fetchedHistoryItem.id,
        volunteerUid: volunteerUid,
        eventId: fetchedHistoryItem.data()![eventIdFieldName],
        volunteerStatus: fetchedHistoryItem.data()![volunteerStatusFieldName]);
  }

  // Stream of all volunteer history from a specific volunteer
  Stream<Iterable<CloudVolunteerHistory>> allVolunteerHistory(
          {required String volunteerUid}) =>
      volunteerHistory.snapshots().map(
            (collection) => collection.docs
                .map((doc) => CloudVolunteerHistory.fromSnapshot(doc))
                .where((history) => history.volunteerUid == volunteerUid),
          );

  // Get all volunteer history from a specific volunteer
  Future<Iterable<CloudVolunteerHistory>> getVolunteerHistory(
      {required String volunteerUid}) async {
    try {
      return await volunteerHistory
          .where(
            volunteerUidFieldName,
            isEqualTo: volunteerUid,
          )
          .get()
          .then(
            (collection) => collection.docs.map(
              (doc) => CloudVolunteerHistory.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllVolunteerHistoryException;
    }
  }
}
