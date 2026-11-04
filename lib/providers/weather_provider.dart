import 'package:flutter/foundation.dart';
import '../models/weather.dart';
import '../repositories/weather_repository.dart';
import '../utils/app_config.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherProvider(this._repository);

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get locationName => AppConfig.locationName;

  Future<void> loadWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _weather = await _repository.getCurrentWeather();
    } catch (e) {
      _error = 'Gagal memuat cuaca. Periksa koneksi internet.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}