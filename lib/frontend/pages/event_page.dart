import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_event.dart';
import 'package:volunteerexpress/backend/eventPage/event_state.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/frontend/constants/routes.dart';
import 'package:volunteerexpress/frontend/enums/menu_action_enums.dart';
import 'package:volunteerexpress/frontend/pages/event_pages/event_table.dart';
import 'package:volunteerexpress/frontend/pages/event_pages/event_form.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load events when the page is built
    context.read<EventBloc>().add(const LoadEvents());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out')),
              ];
            },
            onSelected: (value) async {
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventListState) {
            return EventTable(
              events: state.events,
              onEventSelected: (event) {
                EventBloc eventBloc = context.read<EventBloc>();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventManagementForm(
                        event: event,
                        bloc: eventBloc,
                      ),
                    ));
              },
            );
          } else if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox
              .shrink(); // Default to empty widget if no state matches
        },
      ),
    );
  }
}
