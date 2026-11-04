class EventEntity {
  final String id;
  final String title;
  final String venue;
  final DateTime start; // local time of the venue
  final double lat;
  final double lng;
  final double distanceKm;
  final int going;
  final int capacity;

  const EventEntity({
    required this.id,
    required this.title,
    required this.venue,
    required this.start,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.going,
    required this.capacity,
  });
}
