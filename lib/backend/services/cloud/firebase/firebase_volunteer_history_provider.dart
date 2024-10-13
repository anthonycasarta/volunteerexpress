import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_cloud_storage.dart';

class FirebaseVolunteerHistoryProvider implements FirebaseCloudStorage {
  // Variable containing the table/collection of volunteer history
  final volunteerHistory =
      FirebaseFirestore.instance.collection('volunteer_history');

  Future<CloudVolunteerHistory> addToVolunteerHistory(
      {required ownerUid}) async {
    final document = await volunteerHistory.add({
      ownerUidFieldName: ownerUid,
      eventNameFieldName: '',
      eventDescriptionFieldName: '',
      eventLocationFieldName: '',
      eventSkillsFieldName: '',
      eventUrgencyFieldName: '',
      eventDateFieldName: '',
    });

    final fetchedDocument = await document.get();

    return CloudVolunteerHistory(
      docId: fetchedDocument.id,
      ownerUid: ownerUid,
      eventName: fetchedDocument.data()![eventNameFieldName],
      eventDescription: fetchedDocument.data()![eventDescriptionFieldName],
      eventLocation: fetchedDocument.data()![eventLocationFieldName],
      eventSkills: fetchedDocument.data()![eventSkillsFieldName],
      eventUrgency: fetchedDocument.data()![eventUrgencyFieldName],
      eventDate: fetchedDocument.data()![eventDateFieldName],
    );
  }

  Stream<Iterable<CloudVolunteerHistory>> allVolunteerHistory(
          {required String ownerUId}) =>
      volunteerHistory.snapshots().map(
            (event) => event.docs
                .map((doc) => CloudVolunteerHistory.fromSnapshot(doc))
                .where((volEvent) => volEvent.ownerUid == ownerUId),
          );

  Future<Iterable<CloudVolunteerHistory>> getVolunteerHistory(
      {required String ownerUid}) async {
    // ****************** PUT INSIDE TRY - CATCH BLOCK IN THE FUTURE ***************
    return await volunteerHistory
        .where(
          ownerUidFieldName,
          isEqualTo: ownerUid,
        )
        .get()
        .then(
          (collection) => collection.docs.map(
            (doc) => CloudVolunteerHistory.fromSnapshot(doc),
          ),
        );
  }
}
