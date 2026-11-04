import '../models/weather.dart';
import '../services/weather_service.dart';
import '../utils/app_config.dart';

class WeatherRepository {
  final WeatherService _service;

  WeatherRepository(this._service);

  /// Mengambil JSON dari service lalu mengubahnya menjadi model Weather.
  Future<Weather> getCurrentWeather() async {
    final json = await _service.fetchCurrentWeather(
      latitude: AppConfig.latitude,
      longitude: AppConfig.longitude,
    );
    return Weather.fromJson(json);
  }
}