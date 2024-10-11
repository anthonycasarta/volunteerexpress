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
    on<SaveEvent>(_onSaveEvent);
    on<AddNewEvent>(_onAddNewEvent);
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

  Future<void> _onSaveEvent(SaveEvent event, Emitter<EventState> emit) async {
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

  void _onAddNewEvent(AddNewEvent event, Emitter<EventState> emit) {
    emit(const EventFormState()); // Emit form state for adding a new event
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    try {
      await eventRepository.deleteEvent(event.event); // Delete the event
      emit(const EventInitial()); // Optionally, you can emit a success state or reload events
    } catch (e) {
      emit(EventError(e.toString())); // Emit an error if deleting fails
    }
  }
}
