import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/reports_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  Future<void> eventPDf() async {
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.eventsGeneratePdf();
  }

  Future<void> profilePDf() async {
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.profileGeneratePdf();
  }

  Future<void> eventCSV() async {
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.eventsGenerateCsv();
  }

  Future<void> profileCSV() async {
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.profileGenerateCsv();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the Report Page!',
              style: TextStyle(fontSize: 24),
            ),

            TextButton(
              onPressed: eventPDf,
              child: const Text('Events PDF')

            ),

            TextButton(
              onPressed: eventCSV,
              child: const Text('Events CSV')
            ),

            TextButton(
              onPressed: profilePDf,
              child: const Text('Volunteer PDF')

            ),

            TextButton(
              onPressed: profileCSV,
              child: const Text('Volunteer CSV')

            ),

          ],
        )
      )

    );
  }

}

