import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';
import 'package:intl/intl.dart';
import 'package:volunteerexpress/backend/services/notification_services.dart';
//Import for Firebase initialization

class MatchingFormPage extends StatefulWidget {
  const MatchingFormPage({super.key});

  @override
  State<MatchingFormPage> createState() => _MatchingFormPageState();
}

class _MatchingFormPageState extends State<MatchingFormPage> {
  late final TextEditingController dateController;
  bool firstValue = false;
  bool secondValue = false;
  bool thirdValue = false;
  bool fourthValue = false;
  List<String> eventNames = [];
  List<List<String>> eventSkills = [];
  List<String> eventDates = [];
  List<String> eventIds = [];
  String? selectedEvent;
  List<Map<String, dynamic>> matchedVolunteers = [];
  List<Map<String, dynamic>> selectedVolunteers = [];
  String selectedDate = "";
  String selectedEventID = "";
  // Add Firebase initialization in initState
  final MatchingServices _matchingServices =
      MatchingServices(firestore: FirebaseFirestore.instance);
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    _fetchEventsFromFirestore();
  }
 
  Future<void> _fetchEventsFromFirestore() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('EVENT').get();
      setState(() {
        eventNames =
            snapshot.docs.map((doc) => doc['event_name'] as String).toList();
        eventSkills =
            snapshot.docs.map((doc) {
              List<dynamic> skills = doc['event_skills'] as List<dynamic>;
             return skills.cast<String>();  // Convert dynamic list to List<String>
            }).toList();
        eventDates = 
            snapshot.docs.map((doc) => doc['event_date'] as String).toList();
        eventIds = 
        snapshot.docs.map((doc) => doc['event_id'] as String).toList();
      });
    } catch (e) {
      print('Error fetching events $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matching Form"),
        backgroundColor: primaryAccentColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
              ];
            },
            onSelected: (value) async {
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 500,
                height: 90,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Choose an Event",
                  ),
                  items: eventNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEvent = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an event';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedEvent == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an event'),
                        ),
                      );
                      return;
                    }
                    int selectedIndex = eventNames.indexOf(selectedEvent!);
                    List<String> skillsForEvent = eventSkills[selectedIndex];
                    String date = eventDates[selectedIndex];
                    DateTime parsedDate = DateTime.parse(date);
                    String isoDate = parsedDate.toIso8601String();
                    selectedEventID = eventIds[selectedIndex];
                    matchedVolunteers = await _matchingServices
                        
                        .displayMatchedVolunteers(isoDate,skillsForEvent);
                    if (matchedVolunteers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Volunteers matched the event'),
                        ),
                      );
                    } else {
                      showMatchedVolunteersDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Match Volunteer",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Nav bar
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextOnlyButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, eventPageRoute),
                          label: "Event Form"),
                      TextOnlyButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, profileRoute),
                          label: "Profile Page"),
                      TextOnlyButton(
                          onPressed: () => Navigator.pushNamed(
                              context, volunteerHistoryRoute),
                          label: "Volunteer History"),
                      TextOnlyButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, notificationRoute),
                          label: "Notifications"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void showMatchedVolunteersDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Matched Volunteers'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: matchedVolunteers.map((volunteer) {
                bool isSelected = selectedVolunteers.contains(volunteer);
                return ListTile(
                  title: Text(volunteer['fullName']),
                  trailing: IconButton(
                    icon: Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: primaryAccentColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          selectedVolunteers.remove(volunteer);
                        } else {
                          selectedVolunteers.add(volunteer);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleSelectedVolunteers();
            },
            child: const Text('Confirm Selection'),
          ),
        ],
      );
    },
  );
}
void _handleSelectedVolunteers() async {
  // Placeholder function to handle the selected volunteers
    final NotificationServices notificationServices = 
      NotificationServices(firestore: FirebaseFirestore.instance);
 try{
  for (var volunteer in selectedVolunteers) {
  
      String eventID =  selectedEventID;
      String volID = volunteer['userId'];
         
      
      await _matchingServices.addToVolunteerHistory(
        eventID, 
        volID,
        "Assigned"
      );

      //send notifications to volunteers
      await notificationServices.addNotification(
        'Volunteer Assignment', 
        'You have been assigned to $selectedEvent',
         DateTime.now(), 
         false, 
         volID,
         );
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Volunteers selected and notified successfully')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('error assigning volunteers: $e')),
  );
}
}
}