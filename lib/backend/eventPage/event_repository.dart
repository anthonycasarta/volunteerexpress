import 'package:volunteerexpress/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepository {
  // Dummy list to simulate a data source
  final FirebaseFirestore firestore;

  EventRepository({required this.firestore});

  // Method to fetch events
  Future<List<Event>> fetchEvents() async {
    // Simulate a delay for fetching data
    //await Future.delayed(const Duration(seconds: 2));
    final snapshot = await firestore.collection('events').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Event(
        id: doc.id,
        name: data['name'],
        location: data['location'],
        date: data['date'],
        urgency: data['urgency'],
        requiredSkills: data['requiredSkills'],
        description: data['description'],
      );
    }).toList();
  }

  // Method to add an event
  Future<void> addEvent(Event event) async {

    DocumentReference docRef = firestore.collection('events').doc(event.id);

    await docRef.set({
      'name': event.name,
      'location': event.location,
      'date': event.date,
      'urgency': event.urgency,
      'requiredSkills': event.requiredSkills,
      'description': event.description,
  });
    
  }

  // Method to delete an event
  Future<void> deleteEvent(Event deleteEvent) async {
    await firestore.collection('events').doc(deleteEvent.id).delete();
    
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
    await firestore.collection('events').doc(updateEvent.id).update({
      'id' : updateEvent.id,
      'name': updateEvent.name,
      'location': updateEvent.location,
      'date': updateEvent.date,
      'urgency': updateEvent.urgency,
      'requiredSkills': updateEvent.requiredSkills,
      'description': updateEvent.description,
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
}
