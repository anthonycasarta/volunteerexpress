import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/models/event_model.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_event.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';

//import 'package:firebase_auth/firebase_auth.dart';



class EventManagementForm extends StatefulWidget {
  final Event? event;
  final EventBloc bloc;
  
  const EventManagementForm({super.key, this.event, required this.bloc});

  @override
  State<EventManagementForm> createState() => _EventManagementFormState();
}

class _EventManagementFormState extends State<EventManagementForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // late String userRole = ''; 
  late final TextEditingController eventNameController;
  late final TextEditingController eventDescriptionController;
  late final TextEditingController eventLocationController;
  late final MultiSelectController<String> skillController;

  List<DateTime> selectedDates = [];
  String? selectedUrgency;
  List<String> selectedSkills = [];
  bool isReadOnly = false; 

  
  // Removes and add dates to the picked date list
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

  // The urgency list options
  final List<String> urgencyOptions = [
    'High',
    'Medium',
    'Low',
  ];

  // The required skills options
  var requiredSkills = [
    DropdownItem(label: 'Leadership', value: "Leadership"),
    DropdownItem(label: 'Problem Solving', value: "Problem Solving"),
    DropdownItem(label: 'Creativity', value: "Creativity"),
    DropdownItem(label: 'Adaptability', value: "Adaptability"),
    DropdownItem(label: 'Teamwork', value: "Teamwork"),
    DropdownItem(label: 'Communication', value: "Communication"),
  ];

  // Initialize any controllers or other resources if needed
  @override
  void initState() {
    super.initState();

    /*
    final authService = AuthService.firebase();
    final AuthUser? currentUser = authService.currentUser;
    widget.bloc.add(FetchUserRole(currentUser!.id));
    
    //await Future.delayed(const Duration(milliseconds: 50));
    // print("Fetched role from event page: $userRole");    
    
    if (userRole == "volunteer") {
      isReadOnly = true;
    }
    */
    
    eventNameController = TextEditingController(text: widget.event?.name ?? '');
    eventDescriptionController = TextEditingController(text: widget.event?.description ?? '');
    eventLocationController = TextEditingController(text: widget.event?.location ?? '');
    skillController = MultiSelectController<String>();
    

    if (widget.event != null) {
      eventNameController.text = widget.event!.name;
      eventDescriptionController.text = widget.event!.description;
      eventLocationController.text = widget.event!.location;
      selectedUrgency = widget.event!.urgency;
      selectedDates = [DateTime.parse(widget.event!.date)];
      selectedSkills = widget.event!.requiredSkills;
      //print(selectedSkills);
      
      // You might need to update the MultiSelectController as well

      //skillController.clearAll();
      
      List<DropdownItem<String>> selectedDropdownItems = requiredSkills
        .where((dropdownItem) => selectedSkills.contains(dropdownItem.value))
        .toList(); // Match the actual DropdownItem objects

      for (var item in selectedDropdownItems) {
        item.selected = true; // Mark item as selected
      }

      //print(selectedDropdownItems);

      skillController.selectedItems.addAll(selectedDropdownItems);
      // print('Selected Items in Controller: ${skillController.selectedItems}');
    
      
      setState(() {});
    }
  }

  // Calls the superclass dispose method
  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();
    skillController.dispose();
    super.dispose();
  }

// resets the form
  void resetForm() {
    eventNameController.clear();
    eventLocationController.clear();
    eventDescriptionController.clear();
    selectedUrgency = null;
    selectedDates = [];
    selectedSkills = [];

    setState(() {});
  }


/*
  Future<void> fetchUserRole() async {
    final authService = AuthService.firebase();
    final AuthUser? currentUser = authService.currentUser;

    if (currentUser != null) {
      final role = await widget.bloc.add(userSelector(currentUser.id));
      setState(() {
        userRole = role;
      });
    }
  }

*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management', style: TextStyle(color: textColorLight)),
        backgroundColor: primaryAccentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InfoTextBox(
                    // The Event Name Portion 
                    controller: eventNameController,
                    readOnly: isReadOnly,
                    labelText: 'Event Name',
                    hintText: 'Enter the event name',
                    isRequired: true,
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event Name is required';
                      }
                      return null;
                    },
                  ),

                  // Event Description Portion  
                  const SizedBox(height: 20),
                  InfoTextBox(
                    controller: eventDescriptionController,
                    readOnly: isReadOnly,
                    labelText: 'Event Description',
                    hintText: 'Enter the event desciption',
                    isRequired: true,
                    isMultiline: true,
                    minLines: 2,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event Description is required';
                      }
                      return null;
                    },
                  ),

                  // Event Location 
                  const SizedBox(height: 20),
                  InfoTextBox(
                    controller: eventLocationController,
                    readOnly: isReadOnly,
                    labelText: 'Event Location',
                    hintText: 'Enter the event location',
                    isRequired: true,
                    isMultiline: true,
                    minLines: 2,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event Location is required';
                      }
                      return null;
                    },
                  ),

                  // Required skills Portion
                  const SizedBox(height: 20),
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
                    }
                  ),

                  // Urgency portion 
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

                  // Date Selector 
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

                  



                  // Save button 
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextOnlyButton(
                      onPressed: () {
                        setState(() {});
                        if (_formKey.currentState!.validate() &&
                            selectedDates.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Event saved')),
                          );
                          
                          if (widget.event != null) {
                          
                            final newEvent = Event(
                              eventID: widget.event?.eventID,
                              name: eventNameController.text,
                              location: eventLocationController.text,
                              //date: selectedDates.isNotEmpty ? selectedDates.first.toIso8601String() : '', // Ensure you have a date
                              date: '${selectedDates.first.year}-${selectedDates.first.month.toString().padLeft(2, '0')}-${selectedDates.first.day.toString().padLeft(2, '0')}',
                              urgency: selectedUrgency ?? 'Low', // Provide a default if not set
                              //requiredSkills: selectedSkills.join(','), // Handle as needed
                              requiredSkills: skillController.selectedItems.map((item) => item.value).toList(),
                              description: eventDescriptionController.text,
                              adminId: widget.event?.adminId ?? 'Undefined Admin'
                            );
                            // Update existing event
                            // Call your update function here
                            widget.bloc.add(UpdateEvent(newEvent)); // Example of calling an update event action
                            
                          } else {

                              final authService = AuthService.firebase();
                              final AuthUser? currentUser = authService.currentUser;
                              String? adminID;
                              if (currentUser == null) {
                                // User is not logged in, handle accordingly
                                adminID = "No User Logged in";
                              } else {
                                // User is logged in, get the user ID
                                adminID = currentUser.id; // Assuming AuthUser has an 'id' property for user ID
                              }

                              //const String adminID = "Current User";

                              final newEvent = Event(
                                name: eventNameController.text,
                                location: eventLocationController.text,
                                //date: selectedDates.isNotEmpty ? selectedDates.first.toIso8601String() : '', // Ensure you have a date
                                date: '${selectedDates.first.year}-${selectedDates.first.month.toString().padLeft(2, '0')}-${selectedDates.first.day.toString().padLeft(2, '0')}',
                                urgency: selectedUrgency ?? 'Low', // Provide a default if not set
                                // requiredSkills: selectedSkills.join(','), // Handle as needed
                                requiredSkills: skillController.selectedItems.map((item) => item.value).toList(),
                                description: eventDescriptionController.text,
                                adminId: adminID,
                              );


                            widget.bloc.add(AddEvent(newEvent)); 
                          }
                          
                        
                          Navigator.pop(context);

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill all required fields')),
                          );
                        }
                      },
                      fontSize: 20,
                      label: 'Save Event'),

                      const Spacer(),

                      // Delete Button
                      TextOnlyButton(
                        onPressed: () {
                          // Show a confirmation dialog when Delete Event is pressed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: const Text("Are you sure you want to delete this event?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // If user presses cancel, just close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {

                                      
                                      if (widget.event != null) {
                                        widget.bloc.add(DeleteEvent(widget.event!));
                                      }
                                    
                                      // Handle the delete event logic here
                                      // For example, pop the dialog and navigate back
                                      Navigator.of(context).pop(); // Close the dialog
                                      Navigator.pop(context); // Go back to previous page or handle delete
                                      // You can add more logic here to remove the event from the database or state
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red), // Red color to indicate delete action
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        fontSize: 20,
                        label: "Delete Event",
                      ),
                    ],
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
  final bool readOnly;
  final int? maxLength;
  final bool isMultiline;
  final int? minLines;
  final String? Function(String?)? validator;
  

  const InfoTextBox({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.readOnly,
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
      readOnly: readOnly,
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