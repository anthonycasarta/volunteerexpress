import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_volunteer_history_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/pages/volunteer-history/volunteer_history_list_view.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';
import 'package:volunteerexpress/frontend/custom-widgets/textbuttons/text_only_button.dart';

class VolunteerHistoryPage extends StatefulWidget {
  const VolunteerHistoryPage({super.key});

  @override
  State<VolunteerHistoryPage> createState() => _VolunteerHistoryPageState();
}

class _VolunteerHistoryPageState extends State<VolunteerHistoryPage> {
  late final FirebaseVolunteerHistoryService _volunteerService;
  String get uId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _volunteerService =
        FirebaseVolunteerHistoryService(firestore: FirebaseFirestore.instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // **************************************************************
        // **************************************************************
        // ************* CONNECTION FROM BACKEND TO FRONTEND ************
        // **************************************************************
        // **************************************************************
        //
        StreamBuilder(
      // Get Stream of all volunteer history
      stream: _volunteerService.allVolunteerHistory(volunteerUid: uId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allVolHist =
                  snapshot.data as Iterable<CloudVolunteerHistory>;
              if (allVolHist.isEmpty) {
                // No history available
                return const Center(
                  child: Text(
                    "No History Available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return VolunteerHistoryListView(
                  volunteerHistory: allVolHist,
                  onTap: (event) {
                    // ********************
                    //*******Todo**********
                    // ********************
                  });
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
    //
    // ************************************************************
    // ************************************************************
    // ************************************************************
    // **************************************************************
    // **************************************************************
    // ************* CONNECTION FROM BACKEND TO FRONTEND ************
    // **************************************************************
    // **************************************************************
    // body: StreamBuilder(
    //   // Get Stream of all volunteer history
    //   stream: _volunteerService.allVolunteerHistory(volunteerUid: uId),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //       case ConnectionState.active:
    //         if (snapshot.hasData) {
    //           final allVolHist =
    //               snapshot.data as Iterable<CloudVolunteerHistory>;
    //           return VolunteerHistoryListView(
    //               volunteerHistory: allVolHist,
    //               onTap: (event) {
    //                 // ********************
    //                 //*******Todo**********
    //                 // ********************
    //               });
    //         } else {
    //           return const CircularProgressIndicator();
    //         }
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // ),
    // ************************************************************
    // ************************************************************
    // ************************************************************
  }

  // Column(
  //       children: [
  //         Expanded(child: listView()), // The list view
  //         navBar(context), // Add the navBar here
  //       ],
  //     ),

  Widget listView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return listViewItem(index);
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
        itemCount: 5);
  }

  Widget listViewItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 25,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  eventFields(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: primaryAccentColor,
      ),
      child: const Icon(
        Icons.assignment_outlined,
        size: 25,
        color: Colors.white,
      ),
    );
  }

  Widget message(int index) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: const TextSpan(
        text: 'Event Name',
        style: TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        // children: [
        //   TextSpan(
        //     text: ' Required Skills ',
        //     style: TextStyle(
        //       fontWeight: FontWeight.w400,
        //       color: Colors.red,
        //     ),
        //   ),
        //   TextSpan(
        //     text: ' Event Description',
        //     style: TextStyle(
        //       fontWeight: FontWeight.w400,
        //     ),
        //   )
        // ],
      ),
    );
  }

  Widget eventFields(int index) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(
          //   'Location',
          //   style: TextStyle(
          //     fontSize: 10,
          //   ),
          // ),
          Text(
            'Date',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            'Urgency',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            'Status',
            style: TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 18, 168, 33),
            ),
          ),
        ],
      ),
    );
  }

  Widget navBar(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextOnlyButton(
                onPressed: () => Navigator.pushNamed(context, eventPageRoute),
                label: "Event Form"),
            TextOnlyButton(
                onPressed: () => Navigator.pushNamed(context, profileRoute),
                label: "Profile Page"),
            TextOnlyButton(
                onPressed: () =>
                    Navigator.pushNamed(context, matchingFormRoute),
                label: "Matching Form"),
            TextOnlyButton(
                onPressed: () =>
                    Navigator.pushNamed(context, notificationRoute),
                label: "Notifications"),
          ],
        ),
      ),
    );
  }
}
