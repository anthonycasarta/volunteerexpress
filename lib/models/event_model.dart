
//import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_event_constants.dart'; 

class Event {
  final String adminId;
  final String name;
  final String location;
  final String date;
  final String urgency;
  final String requiredSkills;
  final String description;
  final String? eventID;


  const Event({
    required this.adminId,
    required this.name,
    required this.location,
    required this.date,
    required this.urgency,
    required this.requiredSkills,
    required this.description,
    this.eventID,
  }); 
}


  