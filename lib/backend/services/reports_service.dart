import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportsService {
  final FirebaseFirestore firestore;

  ReportsService({required this.firestore});

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    QuerySnapshot snapshot = await firestore.collection('EVENT').get();
    List<Map<String, dynamic>> events = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    //print("Value of Events: $events");
    return events;
  
  }

  Future<void> eventsGeneratePdf() async {
    List<Map<String, dynamic>> events = await fetchEvents();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Event List',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(height: 20),

              ...events.map(
                  (event) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Name, Date, Urgency in one row
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Name: ${event['event_name'] ?? 'No Name'}'),
                          pw.Text('Date: ${event['event_date'] ?? 'No Date'}'),
                          pw.Text('Urgency: ${event['event_urgency'] ?? 'No Urgency'}'),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      // Location in its own row
                      pw.Text('Location: ${event['event_location'] ?? 'No Location'}'),
                      pw.SizedBox(height: 10),
                      // Required Skills in its own row (list, wrapped)
                      pw.Text('Required Skills:'),
                      pw.Text(
                        event['event_skills']?.join(', ') ?? 'No Required Skills',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 10),
                      // Description in its own row (can be long, handle text wrapping)
                      pw.Text('Description:'),
                      pw.Text(
                        event['event_description'] ?? 'No Description',
                        style: const pw.TextStyle(fontSize: 10),
                        maxLines: 5, // Control the number of lines
                      ),
                      pw.Divider(),
                    ],
                  );
                },
              )
            ],
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/events_report.pdf');
    await outputFile.writeAsBytes(await pdf.save());
    //print('PDF saved to: ${outputFile.path}');

  }

  Future<void> eventsGenerateCsv() async {
    List<Map<String, dynamic>> events = await fetchEvents();

    String csvData = 'Event Name,Location,Date,Urgency,Required Skills,Description\n';

    for (var event in events) {
      String eventName = event['event_name'] ?? 'No Name';
      String location = event['event_location'] ?? 'No Location';
      String date = event['event_date'] ?? 'No Date';
      String urgency = event['event_urgency'] ?? 'No Urgency';
      String description = event['event_description'] ?? 'No Description';

       String requiredSkills = (event['event_skills'] as List<dynamic>?)
          ?.map((e) => e.toString()) 
          .join(', ') ?? 'No Skills';

      csvData += '"$eventName","$location","$date","$urgency","$requiredSkills","$description"\n';
    }

    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/events_report.csv');
    await outputFile.writeAsString(csvData);

  }

  Future<List<Map<String, dynamic>>> fetchProfile() async {
    QuerySnapshot snapshot = await firestore.collection('PROFILE').get();
    List<Map<String, dynamic>> profiles = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return profiles;
  }

  Future<void> profileGeneratePdf() async {
    List<Map<String, dynamic>> profile = await fetchProfile();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Event List',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(height: 20),

              ...profile.map(
                  (profile) {
                    return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Name, Address, City, State, and Zip Code in a Row
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Name: ${profile['fullName'] ?? 'No Name'}'),
                          pw.Text('Address: ${profile['address'] ?? 'No Address'}'),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('City: ${profile['city'] ?? 'No City'}'),
                          pw.Text('State: ${profile['state'] ?? 'No State'}'),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      // Zip Code and Preference in a Row
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Zip Code: ${profile['zipCode'] ?? 'No Zip Code'}'),
                          pw.Text('Preference: ${profile['preference'] ?? 'No Preference'}'),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(), // Divider between each profile
                    ],
                  );
                },
              )
            ],
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/profile_report.pdf');
    await outputFile.writeAsBytes(await pdf.save());
    //print('PDF saved to: ${outputFile.path}');

  }

  Future<void> profileGenerateCsv() async {
    List<Map<String, dynamic>> profiles = await fetchProfile();

     String csvData = 'Name,Address,City,State,Zip Code,Preference\n';

    for (var profile in profiles) {
      String name = profile['fullName'] ?? 'No Name';
      String address = profile['address'] ?? 'No Address';
      String city = profile['city'] ?? 'No City';
      String state = profile['state'] ?? 'No State';
      String zipCode = profile['zipCode'] ?? 'No Zip Code';
      String preference = profile['preference'] ?? 'No Preference';

      csvData += '"$name","$address","$city","$state","$zipCode","$preference"\n';
    }

    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/profile_report.csv');
    await outputFile.writeAsString(csvData);

  }


}