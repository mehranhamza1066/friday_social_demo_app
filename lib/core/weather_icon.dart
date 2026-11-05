// -- weather code -> icon and text
// -- codes are from open-meteo (wmo codes)
// -- null or unknown code = no forecast

import 'package:flutter/material.dart';

IconData weatherIcon(int? code) {
  if (code == null) return Icons.cloud_off_outlined;
  if (code == 0) return Icons.wb_sunny_outlined;
  if (code >= 1 && code <= 3) return Icons.wb_cloudy_outlined;
  if (code == 45 || code == 48) return Icons.foggy;
  if (code >= 51 && code <= 67) return Icons.water_drop_outlined;
  if (code >= 71 && code <= 77) return Icons.ac_unit;
  if (code >= 80 && code <= 82) return Icons.water_drop_outlined;
  if (code >= 95 && code <= 99) return Icons.thunderstorm_outlined;
  return Icons.cloud_off_outlined;
}

String weatherText(int? code) {
  if (code == null) return 'No forecast';
  if (code == 0) return 'Clear sky';
  if (code >= 1 && code <= 3) return 'Cloudy';
  if (code == 45 || code == 48) return 'Fog';
  if (code >= 51 && code <= 67) return 'Rain';
  if (code >= 71 && code <= 77) return 'Snow';
  if (code >= 80 && code <= 82) return 'Rain';
  if (code >= 95 && code <= 99) return 'Thunderstorm';
  return 'No forecast';
}
