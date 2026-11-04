import 'package:get/get.dart';

import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_weather.dart';

class EventController extends GetxController {
  final GetWeather getWeather;

  EventController(this.getWeather);

  final selectedDate = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  final weathers = <WeatherEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWeather();
  }

  Future<void> loadWeather() async {
    weathers.value = await getWeather();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }
}
