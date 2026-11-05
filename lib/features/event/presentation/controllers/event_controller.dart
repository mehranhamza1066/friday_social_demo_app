// -- state of event screen (getx)
// -- start: get location, load events, then weather
// -- weather loads month by month, loadedMonths stops repeat calls
// -- rsvp changes screen first, goes back if it fails

import 'package:get/get.dart';

import '../../../../core/event_full_exception.dart';
import '../../../../core/location_service.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_events.dart';
import '../../domain/usecases/get_weather.dart';
import '../../domain/usecases/rsvp_event.dart';

class EventController extends GetxController {
  final GetWeather getWeather;
  final GetEvents getEvents;
  final RsvpEvent rsvpEvent;

  EventController(this.getWeather, this.getEvents, this.rsvpEvent);

  final selectedDate = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  final radiusKm = 10.obs;
  final usingCity = false.obs; // true if location is not allowed
  final city = cities.first.obs;
  final events = <EventEntity>[].obs;
  final weathers = <String, WeatherEntity>{}.obs;

  List<String> loadedMonths = []; // like "2026-11"
  double lat = cities.first.lat;
  double lng = cities.first.lng;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  Future<void> start() async {
    final position = await LocationService.getUserLocation();
    if (position == null) {
      usingCity.value = true;
    } else {
      lat = position.latitude;
      lng = position.longitude;
    }
    loadAll();
  }

  Future<void> loadAll() async {
    weathers.clear();
    loadedMonths.clear();
    events.value = await getEvents(lat, lng, radiusKm.value);
    loadWeather(focusedDay.value); // no await, events do not wait for weather
  }

  // loads this month and the next week's month, one call for each month
  Future<void> loadWeather(DateTime day) async {
    await loadMonth(day);
    await loadMonth(day.add(const Duration(days: 7)));
  }

  Future<void> loadMonth(DateTime day) async {
    String key = '${day.year}-${day.month}';
    if (loadedMonths.contains(key)) return;
    loadedMonths.add(key);
    try {
      List<WeatherEntity> list = await getWeather(day, lat, lng);
      for (WeatherEntity w in list) {
        weathers[dayKey(w.date)] = w;
      }
    } catch (e) {
      loadedMonths.remove(key); // try again next time
    }
  }

  Future<void> rsvp(EventEntity event) async {
    int index = events.indexWhere((e) => e.id == event.id);
    EventEntity old = events[index];

    events[index] = old.copyWith(going: old.going + 1, isGoing: true);
    try {
      await rsvpEvent(old);
    } catch (e) {
      events[index] = old;
      Get.snackbar('Sorry', e is EventFullException ? 'Event is full' : 'Try again');
    }
  }

  List<EventEntity> eventsOf(DateTime day) {
    return events
        .where((e) => e.start.day == day.day && e.start.month == day.month)
        .toList();
  }

  WeatherEntity? weatherOf(DateTime day) => weathers[dayKey(day)];

  void setRadius(int km) {
    radiusKm.value = km;
    loadAll();
  }

  void setCity(CityEntity newCity) {
    city.value = newCity;
    lat = newCity.lat;
    lng = newCity.lng;
    loadAll();
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
