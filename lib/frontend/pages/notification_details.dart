import 'package:flutter/material.dart';
import 'package:volunteerexpress/frontend/themes/colors.dart';

class NotificationDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final DateTime dateTime;
  final bool requiresAction;

  const NotificationDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime, 
    required this.requiresAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        backgroundColor: primaryAccentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${dateTime.month}-${dateTime.day}-${dateTime.year} at ${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (requiresAction) actionButtons(),
          ],
        ),
      ),
    );
  }
  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle accept action
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Accept"),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle reject action
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Reject"),
        ),
      ],
    );
  }
}
