import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({required super.date, super.code});

  // the API gives one list of dates and one list of codes
  static List<WeatherModel> fromJson(Map<String, dynamic> json) {
    final times = json['daily']['time'] as List;
    final codes = json['daily']['weather_code'] as List;
    return [
      for (var i = 0; i < times.length; i++)
        WeatherModel(date: DateTime.parse(times[i]), code: codes[i]),
    ];
  }
}
