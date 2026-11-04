import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  Future<List<EventEntity>> call(double lat, double lng, int radiusKm) =>
      repository.getEvents(lat, lng, radiusKm);
}
