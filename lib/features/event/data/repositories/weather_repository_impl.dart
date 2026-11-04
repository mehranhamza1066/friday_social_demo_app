import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_source/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource dataSource;

  WeatherRepositoryImpl(this.dataSource);

  @override
  Future<List<WeatherEntity>> getWeather(
    DateTime from,
    DateTime to,
    double lat,
    double lng,
  ) => dataSource.getWeather(from, to, lat, lng);
}
