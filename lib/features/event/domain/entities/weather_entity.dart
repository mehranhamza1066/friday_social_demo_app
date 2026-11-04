class WeatherEntity {
  final DateTime date;
  final int? code; // null = no forecast

  const WeatherEntity({required this.date, this.code});
}
