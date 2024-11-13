import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/models/event_model.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_event_constants.dart'; 


void main() {
  late EventRepository eventRepository;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    // Initialize FakeFirebaseFirestore
    fakeFirestore = FakeFirebaseFirestore();
    // Inject fakeFirestore into EventRepository
    eventRepository = EventRepository(firestore: fakeFirestore);
  });

  group('EventRepository with FakeFirebaseFirestore', () {
    
    test('fetchEvents returns a list of events', () async {
      await fakeFirestore.collection('EVENT').add({
        eventNameFieldName: 'Test Event',
        eventLocationFieldName: 'Test Location',
        eventDateFieldName: '2024-10-15',
        eventUrgencyFieldName: 'High',
        eventSkillsFieldName: ['Communication'],
        eventDescriptionFieldName: 'This is a test event.',
        adminUidFieldName: "Current User",
        eventIDFieldName: "event ID"
    });

    final events = await eventRepository.fetchEvents();

    expect(events.length, 1);
    expect(events.first.name, 'Test Event');
    expect(events.first.location, 'Test Location');
   });


   test('addEvent adds an event to Firestore', () async {
      const event = Event(
        eventID: '1',
        name: 'New Event',
        location: 'New Location',
        date: '2024-11-01',
        urgency: 'Medium',
        requiredSkills: ['Leadership', 'Adaptability'],
        description: 'This is a new event.',
        adminId: "Current User"
      );

      // Add the event using the repository method
      await eventRepository.addEvent(event);

      // Verify that the event was added
      final snapshot = await fakeFirestore.collection('EVENT').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first[eventNameFieldName], 'New Event');
    });


    test('deleteEvent deletes an event from Firestore', () async {
      // First, add a fake event to Firestore
      final docRef = await fakeFirestore.collection('EVENT').add({
        'name': 'Event to Delete',
        'location': 'Some Location',
        'date': '2024-12-01',
        'urgency': 'Low',
        'requiredSkills': 'Creativity',
        'description': 'This event will be deleted.',
      });

      final event = Event(
        eventID: docRef.id,
        name: 'Event to Delete',
        location: 'Some Location',
        date: '2024-12-01',
        urgency: 'Low',
        requiredSkills: ['Creativity'],
        description: 'This event will be deleted.',
        adminId: "Current User",
      );

      // Delete the event using the repository method
      await eventRepository.deleteEvent(event);

      // Verify that the event was deleted
      final snapshot = await fakeFirestore.collection('EVENT').get();
      expect(snapshot.docs.isEmpty, true);
    });


    test('updateEvent updates an event in Firestore', () async {
      // First, add a fake event to Firestore
      final docRef = await fakeFirestore.collection('EVENT').add({
        eventNameFieldName: 'Old Event',
        eventLocationFieldName: 'Old Location',
        eventDateFieldName: '2024-10-10',
        eventUrgencyFieldName: 'Low',
        eventSkillsFieldName: ['Patience'],
        eventDescriptionFieldName: 'This event will be updated.',
        adminUidFieldName: "Current User",
        eventIDFieldName: "event ID"
      });

      final updatedEvent = Event(
        eventID: docRef.id, 
        name: 'Updated Event',
        location: 'Updated Location',
        date: '2024-10-10',
        urgency: 'High',
        requiredSkills: ['Adaptability'],
        description: 'This event has been updated.',
        adminId: "Current User",
      );

      // Update the event using the repository method
      await eventRepository.updateEvent(updatedEvent);

      // Verify that the event was updated
      final snapshot = await fakeFirestore.collection('EVENT').doc(docRef.id).get();
      expect(snapshot.data()?[eventNameFieldName], 'Updated Event');
      expect(snapshot.data()?[eventLocationFieldName], 'Updated Location');
    });


  });
}