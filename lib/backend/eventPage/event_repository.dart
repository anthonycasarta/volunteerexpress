import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_volunteer_history_constants.dart';
import 'package:volunteerexpress/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_event_constants.dart';

class EventRepository {
  // Dummy list to simulate a data source
  final FirebaseFirestore firestore;

  EventRepository({required this.firestore});

  late final event = firestore.collection('EVENT');

  // Method to fetch events
  Future<List<Event>> fetchEvents() async {
    // Simulate a delay for fetching data
    //await Future.delayed(const Duration(seconds: 2));
    final snapshot = await firestore.collection('EVENT').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Event(
          eventID: doc.id,
          name: data[eventNameFieldName],
          location: data[eventLocationFieldName],
          date: data[eventDateFieldName],
          urgency: data[eventUrgencyFieldName],
          requiredSkills: data[eventSkillsFieldName],
          description: data[eventDescriptionFieldName],
          adminId: data[adminUidFieldName]);
    }).toList();
  }

  // Method to add an event
  Future<void> addEvent(Event event) async {
    DocumentReference docRef = firestore.collection('EVENT').doc();
    //DocumentReference docRef = firestore.collection('events').doc(event.eventID);

    await docRef.set({
      eventIDFieldName: docRef.id,
      eventNameFieldName: event.name,
      eventLocationFieldName: event.location,
      eventDateFieldName: event.date,
      eventUrgencyFieldName: event.urgency,
      eventSkillsFieldName: event.requiredSkills,
      eventDescriptionFieldName: event.description,
      adminUidFieldName: event.adminId
    });
  }

  // Method to delete an event
  Future<void> deleteEvent(Event deleteEvent) async {
    await firestore.collection('EVENT').doc(deleteEvent.eventID).delete();

    /* Local Delete Event
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].id == deleteEvent.id) {
        _events[i] = deleteEvent;
        break;
      }
    }
    */
  }

  // Method to update an event
  Future<void> updateEvent(Event updateEvent) async {
    await firestore.collection('EVENT').doc(updateEvent.eventID).update({
      eventIDFieldName: updateEvent.eventID,
      eventNameFieldName: updateEvent.name,
      eventLocationFieldName: updateEvent.location,
      eventDateFieldName: updateEvent.date,
      eventUrgencyFieldName: updateEvent.urgency,
      eventSkillsFieldName: updateEvent.requiredSkills,
      eventDescriptionFieldName: updateEvent.description,
      adminUidFieldName: updateEvent.adminId
    });
    /* Local Update code
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].id == updateEvent.id) {
        _events[i] = updateEvent;
        break;
      }
    }
    */
  }

  Future<Event> getEvent({required String eventId}) async {
    final data = await event
        .where(
          eventIDFieldName,
          isEqualTo: eventId,
        )
        .get()
        .then((value) => value.docs.first.data());

    return Event(
        eventID: eventId,
        name: data[eventNameFieldName],
        location: data[eventLocationFieldName],
        date: data[eventDateFieldName],
        urgency: data[eventUrgencyFieldName],
        requiredSkills: data[eventSkillsFieldName],
        description: data[eventDescriptionFieldName],
        adminId: data[adminUidFieldName]);
  }
}
