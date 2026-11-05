// -- use case: weather for the month of a day
// -- first day to last day of that month, one call

import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<List<WeatherEntity>> call(DateTime day, double lat, double lng) {
    final from = DateTime(day.year, day.month, 1);
    final to = DateTime(day.year, day.month + 1, 0);
    return repository.getWeather(from, to, lat, lng);
  }
}
