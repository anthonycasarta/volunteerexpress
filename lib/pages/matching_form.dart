import 'package:flutter/material.dart';
import 'package:volunteerexpress/constants/routes.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/themes/colors.dart';

class MatchingFormPage extends StatefulWidget {
  const MatchingFormPage({super.key});

  @override
  State<MatchingFormPage> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<MatchingFormPage> {
  bool firstValue = false;
  bool secondValue = false;
  bool thirdValue = false;
  bool fourthValue = false;
  final matchedEvents = ["Event one", "Event two", "Event three"];

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
                    //handle events
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
              const Text(
                'Please choose the people you would like to add:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: firstValue,
                    onChanged: (value) {
                      setState(() {
                        firstValue = value!;
                      });
                    },
                  ),
                  const Text(
                    "Person one",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: secondValue,
                    onChanged: (value) {
                      setState(() {
                        secondValue = value!;
                      });
                    },
                  ),
                  const Text(
                    "Person two",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: thirdValue,
                    onChanged: (value) {
                      setState(() {
                        thirdValue = value!;
                      });
                    },
                  ),
                  const Text(
                    "Person three",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: fourthValue,
                    onChanged: (value) {
                      setState(() {
                        fourthValue = value!;
                      });
                    },
                  ),
                  const Text(
                    "Person four",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form has been updated'),
                      ),
                    );
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
}
