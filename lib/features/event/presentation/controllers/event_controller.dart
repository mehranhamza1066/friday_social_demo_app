import 'package:get/get.dart';

import '../../../../core/location_service.dart';
import '../../domain/entities/city_entity.dart';
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
  final radiusKm = 10.obs; // 5, 10 or 25
  final usingCity = false.obs; // true when the location is not allowed
  final city = cities.first.obs;
  final events = <EventEntity>[].obs;
  final weathers = <String, WeatherEntity>{}.obs; // key is dayKey(date)

  double _lat = cities.first.lat;
  double _lng = cities.first.lng;

  @override
  void onInit() {
    super.onInit();
    _start();
  }

  Future<void> _start() async {
    final location = await LocationService.getUserLocation();
    if (location == null) {
      usingCity.value = true;
      _lat = city.value.lat;
      _lng = city.value.lng;
    } else {
      _lat = location.lat;
      _lng = location.lng;
    }
    await _loadAll();
  }

  Future<void> _loadAll() async {
    weathers.clear();
    events.value = await getEvents(_lat, _lng, radiusKm.value);
    await loadWeather(focusedDay.value);
  }

  Future<void> loadWeather(DateTime day) async {
    try {
      final list = await getWeather(day, _lat, _lng);
      weathers.addAll({for (final w in list) dayKey(w.date): w});
    } catch (_) {
      // no weather, the days show the "no forecast" icon
    }
  }

  List<EventEntity> eventsOf(DateTime day) {
    return events
        .where(
          (e) =>
              e.start.year == day.year &&
              e.start.month == day.month &&
              e.start.day == day.day,
        )
        .toList();
  }

  WeatherEntity? weatherOf(DateTime day) => weathers[dayKey(day)];

  void setRadius(int km) {
    radiusKm.value = km;
    _loadAll();
  }

  void setCity(CityEntity newCity) {
    city.value = newCity;
    _lat = newCity.lat;
    _lng = newCity.lng;
    _loadAll();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    loadWeather(focused);
  }
}
