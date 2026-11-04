import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({required super.date, super.code});

  // api gives a list of dates and a list of codes
  static List<WeatherModel> fromJson(Map<String, dynamic> json) {
    List times = json['daily']['time'];
    List codes = json['daily']['weather_code'];

    List<WeatherModel> list = [];
    for (int i = 0; i < times.length; i++) {
      list.add(WeatherModel(date: DateTime.parse(times[i]), code: codes[i]));
    }
    return list;
  }
}
