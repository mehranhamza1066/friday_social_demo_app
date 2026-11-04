class WeatherEntity {
  final DateTime date;
  final int? code; // null = no forecast

  const WeatherEntity({required this.date, this.code});
}

// "2026-11-04", used as the key of a day
String dayKey(DateTime d) => d.toIso8601String().substring(0, 10);
