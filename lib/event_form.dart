import 'package:flutter/material.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/default_textbutton.dart';
import 'package:volunteerexpress/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/themes/colors.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class EventManagementForm extends StatefulWidget {
  const EventManagementForm({super.key});

  @override
  State<EventManagementForm> createState() => _EventManagementFormState();

}

class _EventManagementFormState extends State<EventManagementForm> {
    final TextEditingController eventNameController = TextEditingController();
    final TextEditingController eventDescriptionController = TextEditingController(); 
    final TextEditingController eventLocationController = TextEditingController();
    final TextEditingController eventDateController = TextEditingController();
    
    List<DateTime> dates = [];

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
        eventDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

    final List<String> requiredSkills = [
      "Teamwork",
      "Communication",
      "Leadership",
      "Problem Solving",
      "Time Management",
      "Technical Skills",
      "Adaptability",
    ];

    final List<String> urgencyOptions = [
      'High',
      'Medium',
      'Low',
    ];

    String? selectedUrgency;

  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management', style: TextStyle(color: textColorLight)),
        backgroundColor: primaryAccentColor,
      ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
          ),
          const SizedBox(height: 20),
          MultiSelectDialogField(
            
            items: requiredSkills
              .map((skill) => MultiSelectItem<String>(skill, skill))
              .toList(),
            title: const Text("Required Skills"),
            selectedColor: primaryAccentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
          buttonText: const Text(
            "Select skills",
            style: TextStyle(
              fontSize: 18,
              color: textColorDark,
            ),
          ),
          onConfirm: (List<String> selected) {
            setState(() {
              selectedSkills = selected;
            });
          },
          ),
          const SizedBox(height: 20),
          const Text(
              'Urgency',
              style: TextStyle(fontSize: 16, color: textColorDark),
          ),
          DropdownButtonFormField<String>(
            value: selectedUrgency,
            hint: const Text('Select Urgency'),
            items: urgencyOptions.map((String urgency) {
              return DropdownMenuItem<String>(
                value: urgency, child: Text(urgency),
                );}).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedUrgency = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select an urgency level' : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              //filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            )
          ),
          const SizedBox(height:20),
          TextField(
                  controller: eventDateController,
                  decoration: const InputDecoration(
                    labelText: 'DATE',
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryAccentColor),
                    ),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                ),
          const SizedBox(height: 20),
          TextOnlyButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event Saved')),
              );
            },
            label: 'Save Event',
            fontSize: 18,
          ),
        ],
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

  const InfoTextBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isRequired = false,
    this.maxLength,
    this.isMultiline = false,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLength: maxLength,
      maxLines: isMultiline ? null : 1,  // Single line by default
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixText: isRequired ? '*' : null,  // Adds a * if required
      ),
    );
  }
}