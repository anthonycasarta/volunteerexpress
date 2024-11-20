import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/backend/services/profile_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController dateController;
  late final TextEditingController nameController;
  late final TextEditingController address1Controller;
  late final TextEditingController cityController;
  late final TextEditingController zipController;
  final ProfileServices _profileServices = ProfileServices(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth
          .instance); // Real Firestore // Instance of ProfileServices

  @override
  void initState() {
    dateController = TextEditingController();
    nameController = TextEditingController();
    address1Controller = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    address1Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  List<DateTime> dates = [];
  String? selectedState;
  List<String> selectedSkills = [];
  final List<String> allSkills = [
    'Leadership',
    'Problem Solving',
    'Creativity',
    'Adaptability',
    'Teamwork',
    'Communication',
  ];

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dates.add(picked);
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void showSkillsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Your Skills'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: allSkills.map((skill) {
                  return CheckboxListTile(
                    title: Text(skill),
                    value: selectedSkills.contains(skill),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSkills.add(skill);
                        } else {
                          selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: majorColorLightMode,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Profile Information',
                  style: TextStyle(fontSize: 24, color: textColorDark),
                ),
                const SizedBox(height: 20),
                InfoTextBox(
                  controller: nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  isRequired: true,
                  maxLength: 50,
                ),
                const SizedBox(height: 20),
                InfoTextBox(
                  controller: address1Controller,
                  labelText: 'Address Line 1',
                  hintText: 'Enter your address',
                  isRequired: true,
                  maxLength: 100,
                ),
                const SizedBox(height: 20),
                InfoTextBox(
                  controller: cityController,
                  labelText: 'City',
                  hintText: 'City Name',
                  isRequired: true,
                  maxLength: 100,
                ),
                const Text(
                  'Select Your State:',
                  style: TextStyle(color: textColorDark, fontSize: 24),
                ),
                DropdownMenu<String>(
                  onSelected: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedState = newValue;
                      });
                    }
                  },
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: 'AL', label: 'AL'),
                    DropdownMenuEntry(value: 'AK', label: 'AK'),
                    DropdownMenuEntry(value: 'AZ', label: 'AZ'),
                    DropdownMenuEntry(value: 'AR', label: 'AR'),
                    DropdownMenuEntry(value: 'CA', label: 'CA'),
                    DropdownMenuEntry(value: 'CO', label: 'CO'),
                    DropdownMenuEntry(value: 'CT', label: 'CT'),
                    DropdownMenuEntry(value: 'DE', label: 'DE'),
                    DropdownMenuEntry(value: 'DC', label: 'DC'),
                    DropdownMenuEntry(value: 'FL', label: 'FL'),
                    DropdownMenuEntry(value: 'GA', label: 'GA'),
                    DropdownMenuEntry(value: 'ID', label: 'ID'),
                    DropdownMenuEntry(value: 'IL', label: 'IL'),
                    DropdownMenuEntry(value: 'IN', label: 'IN'),
                    DropdownMenuEntry(value: 'IA', label: 'IA'),
                    DropdownMenuEntry(value: 'KS', label: 'KS'),
                    DropdownMenuEntry(value: 'KY', label: 'KY'),
                    DropdownMenuEntry(value: 'LA', label: 'LA'),
                    DropdownMenuEntry(value: 'ME', label: 'ME'),
                    DropdownMenuEntry(value: 'MD', label: 'MD'),
                    DropdownMenuEntry(value: 'MA', label: 'MA'),
                    DropdownMenuEntry(value: 'MI', label: 'MI'),
                    DropdownMenuEntry(value: 'MN', label: 'MN'),
                    DropdownMenuEntry(value: 'MS', label: 'MS'),
                    DropdownMenuEntry(value: 'MO', label: 'MO'),
                    DropdownMenuEntry(value: 'MT', label: 'MT'),
                    DropdownMenuEntry(value: 'NE', label: 'NE'),
                    DropdownMenuEntry(value: 'NV', label: 'NV'),
                    DropdownMenuEntry(value: 'NH', label: 'NH'),
                    DropdownMenuEntry(value: 'NJ', label: 'NJ'),
                    DropdownMenuEntry(value: 'NM', label: 'NM'),
                    DropdownMenuEntry(value: 'NY', label: 'NY'),
                    DropdownMenuEntry(value: 'NC', label: 'NC'),
                    DropdownMenuEntry(value: 'ND', label: 'ND'),
                    DropdownMenuEntry(value: 'OH', label: 'OH'),
                    DropdownMenuEntry(value: 'OK', label: 'OK'),
                    DropdownMenuEntry(value: 'OR', label: 'OR'),
                    DropdownMenuEntry(value: 'PA', label: 'PA'),
                    DropdownMenuEntry(value: 'RI', label: 'RI'),
                    DropdownMenuEntry(value: 'SC', label: 'SC'),
                    DropdownMenuEntry(value: 'SD', label: 'SD'),
                    DropdownMenuEntry(value: 'TN', label: 'TN'),
                    DropdownMenuEntry(value: 'TX', label: 'TX'),
                    DropdownMenuEntry(value: 'UT', label: 'UT'),
                    DropdownMenuEntry(value: 'VT', label: 'VT'),
                    DropdownMenuEntry(value: 'VA', label: 'VA'),
                    DropdownMenuEntry(value: 'WA', label: 'WA'),
                    DropdownMenuEntry(value: 'WV', label: 'WV'),
                    DropdownMenuEntry(value: 'WI', label: 'WI'),
                    DropdownMenuEntry(value: 'WY', label: 'WY'),
                  ],
                ),
                const SizedBox(height: 20),
                InfoTextBox(
                  controller: zipController,
                  labelText: 'Zip Code',
                  hintText: zipController.text.length < 5
                      ? 'Make sure to have at least 5 characters'
                      : 'Enter your Zip code',
                  isRequired: true,
                  maxLength: 9,
                ),
                const Text(
                  'Choose your skills:',
                  style: TextStyle(color: textColorDark, fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: showSkillsDialog,
                  child: const Text('Select Skills'),
                ),
                Text(
                  'Selected Skills: ${selectedSkills.join(", ")}',
                  style: const TextStyle(color: textColorDark, fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select the date you are available:',
                  style: TextStyle(color: textColorDark, fontSize: 24),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'DATE',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryAccentColor),
                    ),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                ),
                const Text(
                  'Selected Dates: ',
                  style: TextStyle(color: textColorDark, fontSize: 24),
                ),
                Text(
                  dates.map((date) => date.toString().split(" ")[0]).join(", "),
                  style: const TextStyle(color: textColorDark, fontSize: 15),
                ),
                TextOnlyButton(
                  onPressed: () {
                    // THIS IS BACKEND CODE IMPLEMENTATION
                    String fullName = nameController.text;
                    String address = address1Controller.text;
                    String city = cityController.text;
                    String zip = zipController
                        .text; // Make sure you have a controller for preference

                    _profileServices.saveProfileToFirestore(
                        fullName,
                        address,
                        city,
                        selectedState.toString(),
                        zip,
                        selectedSkills,
                        dates);
                  },
                  fontSize: 20,
                  label: 'Save Changes',
                ),
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
                            onPressed: () => Navigator.pushNamed(
                                context, volunteerHistoryRoute),
                            label: "Volunteer History"),
                        TextOnlyButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, notificationRoute),
                            label: "Notifications"),
                        TextOnlyButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, matchingFormRoute),
                            label: "Matching Form"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isRequired;
  final int? maxLength;
  final bool isMultiline;

  const InfoTextBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isRequired = false,
    this.maxLength,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: isMultiline ? null : 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixText: isRequired ? '*' : null, // Mark required fields with *
      ),
      style: const TextStyle(
        fontSize: 18,
        color: textColorDark,
      ),
    );
  }
}
