import 'package:flutter/material.dart';
import 'package:volunteerexpress/backend/services/reports_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  Future<void> eventPDf(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Events PDF created!'),
        duration: Duration(seconds: 2))
    );
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.eventsGeneratePdf();
    
  }

  Future<void> profilePDf(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Volunteer PDF created!'),
        duration: Duration(seconds: 2))
    );
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.profileGeneratePdf();
    
  }

  Future<void> eventCSV(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Events CSV created!'),
        duration: Duration(seconds: 2))
    );
    final reportsService = ReportsService(firestore: FirebaseFirestore.instance);
    await reportsService.eventsGenerateCsv();
    
  }

  Future<void> profileCSV(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Volunteer CSV created!'),
        duration: Duration(seconds: 2))
    );
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
              'Create your Reports!',
              style: TextStyle(fontSize: 24),
            ),

            TextButton(
              onPressed: () => eventPDf(context),
              child: const Text('Events PDF')

            ),

            TextButton(
              onPressed: () => eventCSV(context),
              child: const Text('Events CSV')
            ),

            TextButton(
              onPressed: () => profilePDf(context),
              child: const Text('Volunteer PDF')

            ),

            TextButton(
              onPressed: () => profileCSV(context),
              child: const Text('Volunteer CSV')

            ),

          ],
        )
      )

    );
  }

}

