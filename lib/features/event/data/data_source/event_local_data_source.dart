import 'dart:math';

import 'package:geolocator/geolocator.dart';

import '../../domain/entities/event_entity.dart';

// Demo events. They are placed around the given point, so there are always
// events near the user (or near the chosen city), at different distances.
class EventLocalDataSource {
  static const _venues = [
    'City Hall',
    'Riverside Park',
    'Central Library',
    'Art Gallery',
    'Sports Arena',
    'Old Market',
    'Music Hall',
    'Tech Hub',
  ];
  static const _distancesKm = [2.0, 4.0, 7.0, 9.0, 12.0, 18.0, 24.0, 40.0];
  static const _hours = [9, 12, 15, 18];

  Future<List<EventEntity>> getEvents(
    double lat,
    double lng,
    int radiusKm,
  ) async {
    final today = DateTime.now();
    final events = <EventEntity>[];

    for (var offset = -30; offset <= 30; offset++) {
      final day = DateTime(today.year, today.month, today.day + offset);
      final count = (day.day % 4) + 1; // 1, 2, 3 or 4 events
      for (var i = 0; i < count; i++) {
        final k = (day.day + i) % _venues.length;
        final angle = k * pi / 4;
        final km = _distancesKm[k];
        final eventLat = lat + km * cos(angle) / 111;
        final eventLng = lng + km * sin(angle) / (111 * cos(lat * pi / 180));

        final distanceKm =
            Geolocator.distanceBetween(lat, lng, eventLat, eventLng) / 1000;
        if (distanceKm > radiusKm) continue;

        final capacity = 50 + k * 25;
        events.add(
          EventEntity(
            id: '${day.toIso8601String()}-$i',
            title: 'Event ${i + 1}',
            venue: _venues[k],
            start: DateTime(day.year, day.month, day.day, _hours[i]),
            lat: eventLat,
            lng: eventLng,
            distanceKm: distanceKm,
            going: (day.day * 7 + i * 13) % (capacity + 1),
            capacity: capacity,
          ),
        );
      }
    }
    return events;
  }
}
