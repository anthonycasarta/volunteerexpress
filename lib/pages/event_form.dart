import 'package:flutter/material.dart';
import 'package:volunteerexpress/constants/routes.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/themes/colors.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class EventManagementForm extends StatefulWidget {
  const EventManagementForm({super.key});

  @override
  State<EventManagementForm> createState() => _EventManagementFormState();
}

class _EventManagementFormState extends State<EventManagementForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController eventNameController;
  late final TextEditingController eventDescriptionController;
  late final TextEditingController eventLocationController;
  late final MultiSelectController<String> skillController;

  List<DateTime> selectedDates = [];

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (selectedDates.contains(pickedDate)) {
          selectedDates.remove(pickedDate);
        } else {
          selectedDates.add(pickedDate);
        }
      });
    }
  }

  final List<String> urgencyOptions = [
    'High',
    'Medium',
    'Low',
  ];

  var requiredSkills = [
    DropdownItem(label: 'Leadership', value: "Leadership"),
    DropdownItem(label: ' Problem Solving', value: " Problem Solving"),
    DropdownItem(label: 'Creativity', value: "Creativity"),
    DropdownItem(label: 'Adaptability', value: "Adaptability"),
    DropdownItem(label: 'Teamwork', value: "Teamwork"),
    DropdownItem(label: 'Communication', value: "Communication"),
  ];

  String? selectedUrgency;
  List<String> selectedSkills = [];

  @override
  void initState() {
    eventNameController = TextEditingController();
    eventDescriptionController = TextEditingController();
    eventLocationController = TextEditingController();
    skillController = MultiSelectController<String>();
    super.initState();
    // Initialize any controllers or other resources if needed
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();
    skillController.dispose();
    super.dispose(); // Call the superclass dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management',
            style: TextStyle(color: textColorLight)),
        backgroundColor: primaryAccentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Event Details',
                style: TextStyle(fontSize: 24, color: textColorDark),
              ),
              const SizedBox(height: 20),
              InfoTextBox(
                controller: eventNameController,
                labelText: 'Event Name',
                hintText: 'Enter the event name',
                isRequired: true,
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InfoTextBox(
                controller: eventDescriptionController,
                labelText: 'Event Description',
                hintText: 'Enter the event desciption',
                isRequired: true,
                isMultiline: true,
                minLines: 2,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InfoTextBox(
                controller: eventLocationController,
                labelText: 'Event Location',
                hintText: 'Enter the event location',
                isRequired: true,
                isMultiline: true,
                minLines: 2,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              // Multi-select dropdown for required skills
              MultiDropdown<String>(
                  items: requiredSkills,
                  controller: skillController,
                  enabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: 'Select Required Skill',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: textColorDark,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select Requiered Skills';
                    }
                    return null;
                  }),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedUrgency,
                decoration: InputDecoration(
                  labelText: selectedUrgency == null ? null : 'Urgency',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryAccentColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                hint: const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: textColorDark,
                  ),
                  child: Text('Select Urgency'),
                ),
                isExpanded: true,
                items: urgencyOptions.map((String urgency) {
                  return DropdownMenuItem<String>(
                    value: urgency,
                    child: Text(
                      urgency,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUrgency = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select an urgency level' : null,
              ),

              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Event Dates',
                  hintText: 'Select event dates',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: selectedDates.isNotEmpty
                      ? selectedDates
                          .map(
                              (date) => date.toLocal().toString().split(' ')[0])
                          .join(', ')
                      : null,
                ),
                readOnly: true,
                onTap: () {
                  selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dates Selection is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextOnlyButton(
                  onPressed: () {
                    setState(() {});
                    if (_formKey.currentState!.validate() &&
                        selectedDates.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Event saved')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill all required fields')),
                      );
                    }
                  },
                  fontSize: 20,
                  label: 'Save Changes'),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                              Navigator.pushNamed(context, matchingFormRoute),
                          label: "Matching Form"),
                      TextOnlyButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, loginRoute),
                          label: "Logout"),
                    ],
                  ),
                ),
              )
            ],
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
  final int? minLines;
  final String? Function(String?)? validator;

  const InfoTextBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isRequired = false,
    this.maxLength,
    this.isMultiline = false,
    this.minLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLength: maxLength,
      maxLines: isMultiline ? null : 1, // Single line by default
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixText: isRequired ? '*' : null, // Adds a * if required
      ),
      validator: validator,
    );
  }
}
