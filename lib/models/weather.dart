/// Cuaca saat ini dari Open-Meteo.
class Weather {
  final double temperature; // °C
  final int humidity; // %
  final double windSpeed; // km/jam
  final int weatherCode; // kode cuaca WMO
  final DateTime? time;

  const Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    this.time,
  });

  /// Membaca JSON response Open-Meteo: { "current": { ... } }
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      time: DateTime.tryParse(current['time'] as String? ?? ''),
    );
  }

  /// Deskripsi dari kode cuaca WMO.
  String get description {
    if (weatherCode == 0) return 'Cerah';
    if (weatherCode == 1) return 'Cerah berawan';
    if (weatherCode == 2) return 'Berawan sebagian';
    if (weatherCode == 3) return 'Mendung';
    if (weatherCode == 45 || weatherCode == 48) return 'Berkabut';
    if (weatherCode >= 51 && weatherCode <= 57) return 'Gerimis';
    if (weatherCode >= 61 && weatherCode <= 67) return 'Hujan';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Salju';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Hujan deras';
    if (weatherCode == 85 || weatherCode == 86) return 'Salju lebat';
    if (weatherCode >= 95) return 'Badai petir';
    return 'Tidak diketahui';
  }
}