import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volunteerexpress/models/event_model.dart';


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
      await fakeFirestore.collection('events').add({
        'name': 'Test Event',
        'location': 'Test Location',
        'date': '2024-10-15',
        'urgency': 'High',
        'requiredSkills': 'Communication',
        'description': 'This is a test event.',
    });

    final events = await eventRepository.fetchEvents();

    expect(events.length, 1);
    expect(events.first.name, 'Test Event');
    expect(events.first.location, 'Test Location');
   });


   test('addEvent adds an event to Firestore', () async {
      const event = Event(
        id: '1',
        name: 'New Event',
        location: 'New Location',
        date: '2024-11-01',
        urgency: 'Medium',
        requiredSkills: 'Leadership',
        description: 'This is a new event.',
      );

      // Add the event using the repository method
      await eventRepository.addEvent(event);

      // Verify that the event was added
      final snapshot = await fakeFirestore.collection('events').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['name'], 'New Event');
    });


    test('deleteEvent deletes an event from Firestore', () async {
      // First, add a fake event to Firestore
      final docRef = await fakeFirestore.collection('events').add({
        'name': 'Event to Delete',
        'location': 'Some Location',
        'date': '2024-12-01',
        'urgency': 'Low',
        'requiredSkills': 'Creativity',
        'description': 'This event will be deleted.',
      });

      final event = Event(
        id: docRef.id, // Using the ID from the document reference
        name: 'Event to Delete',
        location: 'Some Location',
        date: '2024-12-01',
        urgency: 'Low',
        requiredSkills: 'Creativity',
        description: 'This event will be deleted.',
      );

      // Delete the event using the repository method
      await eventRepository.deleteEvent(event);

      // Verify that the event was deleted
      final snapshot = await fakeFirestore.collection('events').get();
      expect(snapshot.docs.isEmpty, true);
    });


    test('updateEvent updates an event in Firestore', () async {
      // First, add a fake event to Firestore
      final docRef = await fakeFirestore.collection('events').add({
        'name': 'Old Event',
        'location': 'Old Location',
        'date': '2024-10-10',
        'urgency': 'Low',
        'requiredSkills': 'Patience',
        'description': 'This event will be updated.',
      });

      final updatedEvent = Event(
        id: docRef.id, // Using the ID from the document reference
        name: 'Updated Event',
        location: 'Updated Location',
        date: '2024-10-10',
        urgency: 'High',
        requiredSkills: 'Adaptability',
        description: 'This event has been updated.',
      );

      // Update the event using the repository method
      await eventRepository.updateEvent(updatedEvent);

      // Verify that the event was updated
      final snapshot = await fakeFirestore.collection('events').doc(docRef.id).get();
      expect(snapshot.data()?['name'], 'Updated Event');
      expect(snapshot.data()?['location'], 'Updated Location');
    });


  });
}