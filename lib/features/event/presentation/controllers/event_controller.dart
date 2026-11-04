import 'package:get/get.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_events.dart';
import '../../domain/usecases/get_weather.dart';

class EventController extends GetxController {
  final GetWeather getWeather;
  final GetEvents getEvents;

  EventController(this.getWeather, this.getEvents);

  final selectedDate = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  final weathers = <String, WeatherEntity>{}.obs; // key is dayKey(date)

  @override
  void onInit() {
    super.onInit();
    loadWeather(focusedDay.value);
  }

  Future<void> loadWeather(DateTime day) async {
    try {
      final list = await getWeather(day);
      weathers.addAll({for (final w in list) dayKey(w.date): w});
    } catch (_) {
      // no weather, the days show the "no forecast" icon
    }
  }

  List<EventEntity> eventsOf(DateTime day) => getEvents(day);

  WeatherEntity? weatherOf(DateTime day) => weathers[dayKey(day)];

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    loadWeather(focused);
  }
}
