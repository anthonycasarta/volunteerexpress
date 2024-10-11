import 'package:volunteerexpress/models/event_model.dart';

class EventRepository {
  // Dummy list to simulate a data source
  final List<Event> _events = [
    const Event(
      name: 'Beach Cleanup',
      location: 'Santa Monica',
      date: '2024-10-15',
      urgency: 'High',
      requiredSkills: 'Leadership, Problem Solving',
      description: 'Join us for a day of cleaning the beach!',
    ),
    const Event(
      name: 'Food Drive',
      location: 'Local Community Center',
      date: '2024-11-05',
      urgency: 'Medium',
      requiredSkills: 'Organization, People Skills',
      description: 'Help us collect and distribute food to those in need.',
    ),
    const Event(
      name: 'Charity Run',
      location: 'Central Park',
      date: '2024-12-01',
      urgency: 'Low',
      requiredSkills: 'Endurance, Fundraising',
      description: 'Participate in a charity run for local nonprofits.',
    ),
  ];

  // Method to fetch events
  Future<List<Event>> fetchEvents() async {
    // Simulate a delay for fetching data
    await Future.delayed(const Duration(seconds: 2));
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
  Future<void> updateEvent(Event event) async {
    // Update logic here
  }
}
