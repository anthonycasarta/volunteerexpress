import 'package:bloc/bloc.dart';
import 'package:volunteerexpress/backend/eventPage/event_event.dart';
import 'package:volunteerexpress/backend/eventPage/event_state.dart';
//import 'package:volunteerexpress/models/event_model.dart';
import 'package:volunteerexpress/backend/eventPage/event_repository.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository; 

  EventBloc(this.eventRepository) : super(const EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<SelectEvent>(_onSelectEvent);
    on<UpdateEvent>(_onSaveEvent);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<FetchUserRole>(_onFetchUserRole);
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

  Future<void> _onFetchUserRole(FetchUserRole event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    try {
       
      final role = await eventRepository.userSelector(event.userID);
      //print("Fetched role From Bloc: $role");  
      emit(UserRoleLoaded(role));
      add(const LoadEvents());
    } catch (e) {
      emit(EventError(e.toString())); 
    }
  }



}
