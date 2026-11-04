class WeatherEntity {
  final DateTime date;
  final int? code; // null means no forecast

  const WeatherEntity({required this.date, this.code});
}

// gives "2026-11-04", we use it as the key of a day
String dayKey(DateTime d) {
  return d.toIso8601String().substring(0, 10);
}
