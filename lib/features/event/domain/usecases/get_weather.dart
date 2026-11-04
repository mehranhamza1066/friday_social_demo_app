import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  // The weather of the 7 days (Monday to Sunday) that hold [day].
  // The weather API only answers for 90 days back and 15 days ahead,
  // so we cut the week to those days.
  Future<List<WeatherEntity>> call(DateTime day) {
    final now = DateTime.now();
    var from = DateTime(day.year, day.month, day.day - (day.weekday - 1));
    var to = DateTime(from.year, from.month, from.day + 6);
    final first = now.subtract(const Duration(days: 90));
    final last = now.add(const Duration(days: 15));
    if (from.isBefore(first)) from = first;
    if (to.isAfter(last)) to = last;
    if (from.isAfter(to)) return Future.value([]);
    return repository.getWeather(from, to);
  }
}
