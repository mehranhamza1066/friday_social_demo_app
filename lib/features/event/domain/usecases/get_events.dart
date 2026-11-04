import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  List<EventEntity> call(DateTime day) => repository.getEvents(day);
}
