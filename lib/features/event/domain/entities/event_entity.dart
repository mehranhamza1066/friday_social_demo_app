// -- event data used by the app
// -- copyWith is used for rsvp (going + 1)

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
  final bool isGoing; // did the user press "RSVP"

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
    this.isGoing = false,
  });

  EventEntity copyWith({int? going, bool? isGoing}) {
    return EventEntity(
      id: id,
      title: title,
      venue: venue,
      start: start,
      lat: lat,
      lng: lng,
      distanceKm: distanceKm,
      going: going ?? this.going,
      capacity: capacity,
      isGoing: isGoing ?? this.isGoing,
    );
  }
}
