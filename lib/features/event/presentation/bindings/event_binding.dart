import 'package:get/get.dart';

import '../../data/data_source/weather_local_data_source.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/usecases/get_weather.dart';
import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EventController(
        GetWeather(WeatherRepositoryImpl(WeatherLocalDataSource())),
      ),
    );
  }
}
