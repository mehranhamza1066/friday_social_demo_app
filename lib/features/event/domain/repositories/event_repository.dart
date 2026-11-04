import '../entities/event_entity.dart';

abstract class EventRepository {
  List<EventEntity> getEvents(DateTime day);
}
