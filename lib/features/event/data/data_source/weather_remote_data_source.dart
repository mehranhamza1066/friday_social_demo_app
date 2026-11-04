import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  // used when the user does not allow the location
  static const _defaultLat = 51.5;
  static const _defaultLng = -0.12;

  Future<({double lat, double lng})> _getLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return (lat: _defaultLat, lng: _defaultLng);
      }
      final position = await Geolocator.getCurrentPosition();
      return (lat: position.latitude, lng: position.longitude);
    } catch (_) {
      return (lat: _defaultLat, lng: _defaultLng);
    }
  }

  Future<List<WeatherModel>> getWeather(DateTime from, DateTime to) async {
    final location = await _getLocation();
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location.lat}',
      'longitude': '${location.lng}',
      'daily': 'weather_code',
      'timezone': 'auto',
      'start_date': from.toIso8601String().substring(0, 10),
      'end_date': to.toIso8601String().substring(0, 10),
    });
    final response = await http.get(uri);
    return WeatherModel.fromJson(jsonDecode(response.body));
  }
}
