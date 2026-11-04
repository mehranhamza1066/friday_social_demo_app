import 'package:get/get.dart';

import '../../data/data_source/event_local_data_source.dart';
import '../../data/data_source/weather_remote_data_source.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/usecases/get_events.dart';
import '../../domain/usecases/get_weather.dart';
import '../../domain/usecases/rsvp_event.dart';
import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    final eventRepository = EventRepositoryImpl(EventLocalDataSource());
    Get.lazyPut(
      () => EventController(
        GetWeather(WeatherRepositoryImpl(WeatherRemoteDataSource())),
        GetEvents(eventRepository),
        RsvpEvent(eventRepository),
      ),
    );
  }
}
