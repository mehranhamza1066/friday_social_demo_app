import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  // One call for the whole month that holds [day], not one call per day.
  // The weather API only answers for 90 days back and 15 days ahead,
  // so we cut the month to those days.
  Future<List<WeatherEntity>> call(DateTime day, double lat, double lng) {
    final now = DateTime.now();
    var from = DateTime(day.year, day.month, 1);
    var to = DateTime(day.year, day.month + 1, 0);
    final first = now.subtract(const Duration(days: 90));
    final last = now.add(const Duration(days: 15));
    if (from.isBefore(first)) from = first;
    if (to.isAfter(last)) to = last;
    if (from.isAfter(to)) return Future.value([]);
    return repository.getWeather(from, to, lat, lng);
  }
}
