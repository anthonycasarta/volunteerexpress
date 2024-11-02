import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_exceptions/cloud_volunteer_history_exceptions.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_volunteer_history_service.dart';

void main() async {
  // Mock Firestore
  final fakeFirestore = FakeFirebaseFirestore();
  final mockVolunteerHistoryService =
      FirebaseVolunteerHistoryService(firestore: fakeFirestore);
  final volunteerHistory = fakeFirestore.collection('volunteer_history');

  // Mock variables
  const mockVId = '1218473740ihdqgsu';
  const mockEid = '238dg7s9sdjsd883h4';
  const mockDocId = 'asdkjbwdu289429od9';
  const mockVStatus = 'Assigned';

  group('updateVolunteerStatus', () {
    test(
        'CouldNotUpdateVolunteerStatusException thrown on FirebaseException when updating',
        () {
      // Setting invocation behavior on fake firestore
      whenCalling(Invocation.method(#update, null))
          .on(volunteerHistory)
          .thenThrow(FirebaseException(plugin: 'firestore'));

      // Calling FirebaseVolunteerHistoryService
      expect(
          () async => mockVolunteerHistoryService.updateVolunteerStatus(
                volunteerUid: mockVId,
                docId: mockDocId,
                volunteerStatus: mockVStatus,
              ),
          throwsA(isA<CouldNotUpdateVolunteerStatusException>()));
    });

    test('Updates the correct doc', () async {
      final mockHistory = await volunteerHistory.add({
        volunteerUidFieldName: mockVId,
        eventIdFieldName: mockEid,
        volunteerStatusFieldName: 'Assigned',
      });

      final fetchedDocId = mockHistory.id;

      await mockVolunteerHistoryService.updateVolunteerStatus(
          volunteerUid: mockVId,
          docId: fetchedDocId,
          volunteerStatus: 'Active');

      // Grab what's stored in fake firestore
      final snapshot =
          await fakeFirestore.collection('volunteer_history').get();

      // Ensure one document is added
      expect(snapshot.docs.length, 1);

      // Grab the only document
      final fetchedHistory = snapshot.docs.first;

      expect(fetchedHistory.get(volunteerStatusFieldName), 'Active');

      await volunteerHistory.doc(mockHistory.id).delete();
    });
  });

  group('addToVolunteerHistory', () {
    test('Function returns type of Future<CloudVolunteerHistory>', () async {
      final mockHistory = await mockVolunteerHistoryService
          .addToVolunteerHistory(volunteerUid: mockVId, eventId: mockEid);
      await expectLater(mockHistory, isA<CloudVolunteerHistory>());

      volunteerHistory.doc(mockHistory.docId).delete();
    });

    test('Function successfully adds correct history to Firestore', () async {
      // Use function to add history
      final mockHistory = await mockVolunteerHistoryService
          .addToVolunteerHistory(volunteerUid: mockVId, eventId: mockEid);

      // Grab what's stored in fake firestore
      final snapshot =
          await fakeFirestore.collection('volunteer_history').get();

      // Ensure one document is added
      //expect(snapshot.docs.length, 1);

      // Grab the only document
      final fetchedHistory = snapshot.docs.first;

      // Check if the values match
      expect(fetchedHistory.get(volunteerUidFieldName), mockVId);
      expect(fetchedHistory.get(eventIdFieldName), mockEid);
      expect(fetchedHistory.get(volunteerStatusFieldName), mockVStatus);

      await volunteerHistory.doc(mockHistory.docId).delete();
    });

    test('Function returns correct number of history', () async {
      // Add 3 histories to one volunteer
      final mockHist1 = await mockVolunteerHistoryService.addToVolunteerHistory(
          volunteerUid: mockVId, eventId: mockEid);
      final mockHist2 = await mockVolunteerHistoryService.addToVolunteerHistory(
          volunteerUid: mockVId, eventId: 'sjdb9869sdb7');
      final mockHist3 = await mockVolunteerHistoryService.addToVolunteerHistory(
          volunteerUid: mockVId, eventId: 'ands7a3dbia7');

      // Grab what's in the doc
      final snapshot =
          await fakeFirestore.collection('volunteer_history').get();

      // Get the number of docs in fake firestore
      final len = snapshot.docs.length;

      // There should only be 3 docs the one volunteer
      expect(len, 3);

      await volunteerHistory.doc(mockHist1.docId).delete();
      await volunteerHistory.doc(mockHist2.docId).delete();
      await volunteerHistory.doc(mockHist3.docId).delete();
    });
  });

  group('allVolunteerHistory', () {
    test('Function returns Stream<Iterable<CloudVolunteerHistory>>', () async {
      // Add history to 3 different volunteers
      final mockHist1 = await volunteerHistory
          .add({volunteerUidFieldName: mockVId, eventIdFieldName: mockEid});
      final mockHist2 = await volunteerHistory.add({
        volunteerUidFieldName: 'ajsdbawkau278qe7',
        eventIdFieldName: 'sjdb9869sdb7'
      });
      final mockHist3 = await volunteerHistory.add({
        volunteerUidFieldName: 'ashdvwy73qe9ug2',
        eventIdFieldName: 'ands7a3dbia7'
      });

      await expectLater(
          mockVolunteerHistoryService.allVolunteerHistory(
              volunteerUid: mockVId),
          isA<Stream<Iterable<CloudVolunteerHistory>>>());

      await volunteerHistory.doc(mockHist1.id).delete();
      await volunteerHistory.doc(mockHist2.id).delete();
      await volunteerHistory.doc(mockHist3.id).delete();
    });
  });

  group('getVolunteerHistory', () {
    test('Function returns Future<Iterable<CloudVolunteerHistory>>', () async {
      await expectLater(
          mockVolunteerHistoryService.getVolunteerHistory(
              volunteerUid: mockVId),
          isA<Future<Iterable<CloudVolunteerHistory>>>());
    });

    test('Function returns the correct number of histories for a volunteer',
        () async {
      // Add 2 histories for 1 voluunteer and only 1 history for another
      final mockHist1 = await volunteerHistory
          .add({volunteerUidFieldName: mockVId, eventIdFieldName: mockEid});
      final mockHist2 = await volunteerHistory.add({
        volunteerUidFieldName: 'ajshdbw7938uebdg7a',
        eventIdFieldName: 'sjdb9869sdb7'
      });
      final mockHist3 = await volunteerHistory.add(
          {volunteerUidFieldName: mockVId, eventIdFieldName: 'ands7a3dbia7'});

      // Get the histories for one volunteer
      final totalHistoryV1 = await mockVolunteerHistoryService
          .getVolunteerHistory(volunteerUid: mockVId);

      // Get the number of histories
      final totalHistoryV1Len = totalHistoryV1.length;

      // Get the histories for one volunteer
      final totalHistoryV2 = await mockVolunteerHistoryService
          .getVolunteerHistory(volunteerUid: 'ajshdbw7938uebdg7a');

      // Get the number of histories
      final totalHistoryV2Len = totalHistoryV2.length;

      // There should only be two for the 1 volunteer
      expect(totalHistoryV1Len, 2);

      // There should only be 1 for the other volunteer
      expect(totalHistoryV2Len, 1);

      await volunteerHistory.doc(mockHist1.id).delete();
      await volunteerHistory.doc(mockHist2.id).delete();
      await volunteerHistory.doc(mockHist3.id).delete();
    });
  });
}
