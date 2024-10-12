import 'package:volunteerexpress/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepository {
  // Dummy list to simulate a data source
  final FirebaseFirestore firestore;

  EventRepository({required this.firestore});
  /* Local Testing Events
  final List<Event> _events = [
    const Event(
      id: "1",
      name: 'Beach Cleanup',
      location: 'Santa Monca',
      date: '2024-10-15',
      urgency: 'High',
      requiredSkills: 'Leadership, Problem Solving, Adaptability, ',
      description: 'Join us for a day of cleaning the beach!',
    ),
    const Event(
      id: "2",
      name: 'Food Drive',
      location: 'Local Community Center',
      date: '2024-11-05',
      urgency: 'Medium',
      requiredSkills: 'Communication, Adaptability',
      description: 'Help us collect and distribute food to those in need.',
    ),
    const Event(
      id: "3",
      name: 'Charity Run',
      location: 'Central Park',
      date: '2024-12-01',
      urgency: 'Low',
      requiredSkills: 'Leadership, Creativity, Adaptability',
      description: 'Participate in a charity run for local nonprofits.',
    ),
  ];
  */


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
    await firestore.collection('events').add({
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
