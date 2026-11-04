import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_source/weather_local_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherLocalDataSource dataSource;

  WeatherRepositoryImpl(this.dataSource);

  @override
  Future<List<WeatherEntity>> getWeather() => dataSource.getWeather();
}
