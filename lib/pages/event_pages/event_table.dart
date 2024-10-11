import 'package:flutter/material.dart';
import 'package:volunteerexpress/models/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_event.dart';
import 'package:volunteerexpress/pages/event_pages/event_form.dart';


class EventTable extends StatelessWidget   {
  final List<Event> events;
  final Function(Event) onEventSelected;

  const EventTable({super.key, required this.events, required this.onEventSelected});

  @override 
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            DataTable(
              headingRowHeight: 60,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 100,
              columns: const [
                DataColumn(label: Text("Name", style: TextStyle(fontSize: 18))),
                DataColumn(label: Text('Location', style: TextStyle(fontSize: 18))),
                DataColumn(label: Text('Date', style: TextStyle(fontSize: 18))),
                DataColumn(label: Text("Urgency", style: TextStyle(fontSize: 18))),

              ],
              rows: events.map((event) {
              
                return DataRow(
                  cells: [
                    DataCell(Text(event.name, style: const TextStyle(fontSize: 18))),
                    DataCell(Text(event.location, style: const TextStyle(fontSize: 18))),
                    DataCell(Text(event.date, style: const TextStyle(fontSize: 18))),
                    DataCell(Text(event.urgency, style: const TextStyle(fontSize: 18))),
                  ],
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      onEventSelected(event);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                EventBloc eventBloc = context.read<EventBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventManagementForm(
                      event: null,
                      bloc: eventBloc,
                    ),
                  ),
                );
              },
              child: const Text('Add Eevnt', style: TextStyle(fontSize: 18),)


            )

          ],  
        ) 
      );
  }      
}