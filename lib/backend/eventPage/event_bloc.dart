import 'package:bloc/bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_event.dart';
import 'package:volunteerexpress/backend/eventPage/event_state.dart';
//import 'package:volunteerexpress/models/event_model.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';
 // Add this if you have a repository to manage events

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository; // Assuming you have a repository for events

  EventBloc(this.eventRepository) : super(const EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<SelectEvent>(_onSelectEvent);
    on<UpdateEvent>(_onSaveEvent);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    try {
      final events = await eventRepository.fetchEvents(); // Fetch events from the repository
      emit(EventListState(events: events));
    } catch (e) {
      emit(EventError(e.toString())); // Emit an error if fetching fails
    }
  }

  void _onSelectEvent(SelectEvent event, Emitter<EventState> emit) {
    emit(EventFormState(event: event.event));
  }

  Future<void> _onSaveEvent(UpdateEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    try {
      await eventRepository.updateEvent(event.event); // Save the event
      // After saving, load the events again
      final events = await eventRepository.fetchEvents(); 
      emit(EventListState(events: events));
    } catch (e) {
      emit(EventError(e.toString())); // Emit an error if saving fails
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
  emit(const EventLoading()); // Emit loading state
  try {
    await eventRepository.addEvent(event.event); // Save the new event
    final events = await eventRepository.fetchEvents(); // Fetch updated events
    emit(EventListState(events: events)); // Emit the updated list of events
  } catch (e) {
    emit(EventError(e.toString())); // Emit an error if adding fails
  }
}

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
  emit(const EventLoading());
  try {
    await eventRepository.deleteEvent(event.event); // Delete the event using the ID
    final events = await eventRepository.fetchEvents(); // Fetch the updated events list
    emit(EventListState(events: events)); // Emit the updated state
  } catch (e) {
    emit(EventError(e.toString())); // Emit an error if deletion fails
  }
}
}
