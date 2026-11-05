// -- calls open-meteo api, no api key needed
// -- one call = one date range (we send a month)

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  Future<List<WeatherModel>> getWeather(
    DateTime from,
    DateTime to,
    double lat,
    double lng,
  ) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$lat',
      'longitude': '$lng',
      'daily': 'weather_code',
      'timezone': 'auto',
      'start_date': from.toIso8601String().substring(0, 10),
      'end_date': to.toIso8601String().substring(0, 10),
    });
    final response = await http.get(uri);
    return WeatherModel.fromJson(jsonDecode(response.body));
  }
}
