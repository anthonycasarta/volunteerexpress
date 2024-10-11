import 'package:volunteerexpress/models/event_model.dart';

class EventRepository {
  // Dummy list to simulate a data source
  final List<Event> _events = [
    Event(
      id: "1",
      name: 'Beach Cleanup',
      location: 'Santa Monca',
      date: '2024-10-15',
      urgency: 'High',
      requiredSkills: 'Leadership, Problem Solving, Adaptability, ',
      description: 'Join us for a day of cleaning the beach!',
    ),
    Event(
      id: "2",
      name: 'Food Drive',
      location: 'Local Community Center',
      date: '2024-11-05',
      urgency: 'Medium',
      requiredSkills: 'Communication, Adaptability',
      description: 'Help us collect and distribute food to those in need.',
    ),
    Event(
      id: "3",
      name: 'Charity Run',
      location: 'Central Park',
      date: '2024-12-01',
      urgency: 'Low',
      requiredSkills: 'Leadership, Creativity, Adaptability',
      description: 'Participate in a charity run for local nonprofits.',
    ),
  ];

  // Method to fetch events
  Future<List<Event>> fetchEvents() async {
    // Simulate a delay for fetching data
    //await Future.delayed(const Duration(seconds: 2));
    return _events;
  }

  // Method to add an event
  Future<void> addEvent(Event event) async {
    _events.add(event);
  }

  // Method to delete an event
  Future<void> deleteEvent(Event event) async {
    _events.remove(event);
  }

  // Method to update an event
  Future<void> updateEvent(Event updateEvent) async {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].id == updateEvent.id) {
        _events[i] = updateEvent;
        break;
      }
    }
  }
}
