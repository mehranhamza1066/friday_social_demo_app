import '../../../../core/event_full_exception.dart';
import '../../domain/entities/event_entity.dart';

// demo events, there is no real server
class EventLocalDataSource {
  List<String> venues = ['City Hall', 'Park', 'Library', 'Gallery', 'Arena', 'Market', 'Music Hall', 'Tech Hub'];
  List<double> distances = [2, 4, 7, 9, 12, 18, 24, 40];

  Future<List<EventEntity>> getEvents(double lat, double lng, int radiusKm) async {
    List<EventEntity> events = [];
    DateTime today = DateTime.now();

    for (int d = -30; d <= 30; d++) {
      DateTime day = DateTime(today.year, today.month, today.day + d);

      // every day has 1, 2, 3 or 4 events
      for (int i = 0; i < (day.day % 4) + 1; i++) {
        int k = (day.day + i) % 8;
        if (distances[k] > radiusKm) continue; // too far

        int capacity = 50 + k * 25;
        int going = i == 3 ? capacity : (day.day * 7 + i * 13) % capacity; // 4th one is full
        events.add(EventEntity(
          id: '${day.toIso8601String()}-$i',
          title: 'Event ${i + 1}',
          venue: venues[k],
          start: DateTime(day.year, day.month, day.day, 9 + i * 3),
          lat: lat + distances[k] / 111, // 1 degree is about 111 km
          lng: lng,
          distanceKm: distances[k],
          going: going,
          capacity: capacity,
        ));
      }
    }
    return events;
  }

  // fake server, says full when there is no space
  Future<void> rsvp(EventEntity event) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (event.going >= event.capacity) throw EventFullException();
  }
}
