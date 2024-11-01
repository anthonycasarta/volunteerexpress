import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/matching_services.dart';
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
  final matchedEvents = [
    "Hands-on Work",
    "Delivery-Driving",
    "Sales Assistance",
    "Food Packing"
  ];
  String? selectedEvent;
  List<Map<String, dynamic>> matchedVolunteers = [];
  String selectedDate  = "";
  // Add Firebase initialization in initState
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
   
  }
  final MatchingServices _matchingServices = MatchingServices(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matching Form"),
        backgroundColor: primaryAccentColor,
        foregroundColor: Colors.white,
        centerTitle: true,
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
                  items: matchedEvents.map((String value) {
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
              Container(
                width: 500,
                height: 90,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Select a Date"
                  ),
                  controller: dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                      if (pickedDate != null){
                        setState(() {
                          dateController.text =
                          pickedDate.toIso8601String(); 
                          selectedDate = pickedDate.toIso8601String();
                        });
                      }
                  },
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please select a date';
                    }
                    return null;
                  },
                )
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
                    matchedVolunteers = await _matchingServices.displayMatchedVolunteers(selectedEvent.toString(),selectedDate); 
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
                      TextOnlyButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, loginRoute),
                          label: "Logout"),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: matchedVolunteers.map((volunteer) {
              return Text(volunteer['fullName']);
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
