import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({required super.date, super.code});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(date: DateTime.parse(json['date']), code: json['code']);
  }
}
