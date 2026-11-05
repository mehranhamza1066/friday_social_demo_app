// -- contract for weather
// -- get weather between two dates

import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<List<WeatherEntity>> getWeather(
    DateTime from,
    DateTime to,
    double lat,
    double lng,
  );
}
