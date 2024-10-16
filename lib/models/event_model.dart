class Event {
  final String? id;
  final String name;
  final String location;
  final String date;
  final String urgency;
  final String requiredSkills;
  final String description;

  const Event({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.urgency,
    required this.requiredSkills,
    required this.description,
  }); 
}