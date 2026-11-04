import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class RsvpEvent {
  final EventRepository repository;

  RsvpEvent(this.repository);

  Future<void> call(EventEntity event) => repository.rsvp(event);
}
