import '../../domain/entities/event_entity.dart';

// demo events: every day has 1, 2, 3 or 4 events
class EventLocalDataSource {
  List<EventEntity> getEvents(DateTime day) {
    final count = (day.day % 4) + 1;
    return [
      for (var i = 1; i <= count; i++)
        EventEntity(title: 'Event $i', date: day),
    ];
  }
}
