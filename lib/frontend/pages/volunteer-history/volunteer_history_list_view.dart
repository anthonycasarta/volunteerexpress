import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_volunteer_history.dart';

typedef VolunteerHistoryCallBack = void Function(
    CloudVolunteerHistory volunteerHistory);

class VolunteerHistoryListView extends StatelessWidget {
  final Iterable<CloudVolunteerHistory> volunteerHistory;
  final VolunteerHistoryCallBack onTap;

  const VolunteerHistoryListView({
    super.key,
    required this.volunteerHistory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: volunteerHistory.length,
        itemBuilder: (context, index) {
          final event = volunteerHistory.elementAt(index);
          return ListTile(
            onTap: () {
              onTap(event);
            },
          );
        });
  }
}
