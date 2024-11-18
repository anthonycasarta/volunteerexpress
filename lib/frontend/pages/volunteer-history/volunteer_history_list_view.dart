import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';
import 'package:volunteerexpress/models/event_model.dart';

typedef VolunteerHistoryCallBack = void Function(
    CloudVolunteerHistory volunteerHistory);

class VolunteerHistoryListView extends StatelessWidget {
  final Iterable<CloudVolunteerHistory> volunteerHistory;
  final VolunteerHistoryCallBack onTap;
  final eventRepo = EventRepository(firestore: FirebaseFirestore.instance);

  VolunteerHistoryListView({
    super.key,
    required this.volunteerHistory,
    required this.onTap,
  });

  Future<Event> fetchEvent(id) async {
    return await eventRepo.getEvent(eventId: id);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: volunteerHistory.length,
        itemBuilder: (context, index) {
          final eventId = volunteerHistory.elementAt(index).eventId;
          final status = volunteerHistory.elementAt(index).volunteerStatus;
          return FutureBuilder(
              future: fetchEvent(eventId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final event = snapshot.data!;
                    return ListTile(
                      onTap: () {
                        //onTap(event);
                      },
                      title: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event
                            RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: event.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            // Properties
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                right: 20,
                                left: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date: ${event.date}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    'Urgency: ${event.urgency}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    status,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 18, 168, 33),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  default:
                    return const CircularProgressIndicator();
                }
              });
        });
  }
}
