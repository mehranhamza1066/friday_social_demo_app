import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getEvents(double lat, double lng, int radiusKm);

  // throws EventFullException when the event is full
  Future<void> rsvp(EventEntity event);
}
