import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../data_source/event_local_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource dataSource;

  EventRepositoryImpl(this.dataSource);

  @override
  Future<List<EventEntity>> getEvents(double lat, double lng, int radiusKm) =>
      dataSource.getEvents(lat, lng, radiusKm);
}
