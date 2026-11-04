import '../models/weather_model.dart';

// demo data, the same shape the weather API gives
class WeatherLocalDataSource {
  Future<List<WeatherModel>> getWeather() async {
    final json = [
      {'date': '2026-11-03', 'code': 0},
      {'date': '2026-11-04', 'code': 61},
      {'date': '2026-11-05', 'code': 95},
    ];
    return json.map(WeatherModel.fromJson).toList();
  }
}
