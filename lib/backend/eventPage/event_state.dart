import 'package:equatable/equatable.dart';
import 'package:volunteerexpress/models/event_model.dart';


abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

// Inital State
class EventInitial extends EventState {
  const EventInitial();
}

// State when loading
class EventLoading extends EventState {
  const EventLoading();
}

// State when the events are loaded
class EventListState extends EventState {
  final List<Event> events;

  const EventListState({required this.events});

  @override
  List<Object> get props => [events];
}

// State for the Event Form
class EventFormState extends EventState {
  final Event? event; // null for a new event

  const EventFormState({this.event});

  @override
  List<Object> get props => [event ?? const Event(name: '', location: '', date: '', urgency: '', requiredSkills: [], description: '', adminId: '')];
}

// State when Error in loading events
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override 
  List<Object> get props => [message];
}