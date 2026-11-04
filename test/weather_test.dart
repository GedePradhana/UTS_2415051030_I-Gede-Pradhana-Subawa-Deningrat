import 'package:flutter_test/flutter_test.dart';
import 'package:kontrakanku/models/weather.dart';

void main() {
  test('Weather.fromJson membaca response Open-Meteo', () {
    final json = {
      'latitude': -8.5,
      'longitude': 115.26,
      'current': {
        'time': '2026-11-04T10:15',
        'interval': 900,
        'temperature_2m': 29.4,
        'relative_humidity_2m': 78,
        'wind_speed_10m': 8.2,
        'weather_code': 2,
      },
    };

    final weather = Weather.fromJson(json);

    expect(weather.temperature, 29.4);
    expect(weather.humidity, 78);
    expect(weather.windSpeed, 8.2);
    expect(weather.description, 'Berawan sebagian');
  });
}