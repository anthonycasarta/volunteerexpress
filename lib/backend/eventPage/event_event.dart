import 'package:equatable/equatable.dart';
import 'package:volunteerexpress/models/event_model.dart';


abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
   List<Object?> get props => [];
}

// Event to load all Events
class LoadEvents extends EventEvent {
  const LoadEvents();
}

// Event to Select an Event 
class SelectEvent extends EventEvent {
  final Event event;

  const SelectEvent(this.event);

  @override
  List<Object?> get props => [event];

}

// Event to Save an Event 
class SaveEvent extends EventEvent {
  final Event event;

  const SaveEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class AddNewEvent extends EventEvent {
  const AddNewEvent();
}

class DeleteEvent extends EventEvent {
  final Event event;

  const DeleteEvent(this.event);

  @override
  List<Object?> get props => [event];
}