import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import '../theme/app_colors.dart';

IconData weatherIcon(int code) {
  if (code == 0) return Icons.wb_sunny_outlined;
  if (code <= 3) return Icons.wb_cloudy_outlined;
  if (code == 45 || code == 48) return Icons.cloud_outlined;
  if (code >= 51 && code <= 67) return Icons.umbrella_outlined;
  if (code >= 71 && code <= 77) return Icons.ac_unit;
  if (code >= 80 && code <= 82) return Icons.umbrella_outlined;
  if (code >= 95) return Icons.thunderstorm_outlined;
  return Icons.cloud_outlined;
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: _content(provider),
    );
  }

  Widget _content(WeatherProvider provider) {
    // 1. Loading
    if (provider.isLoading) {
      return const _StatusRow(
        leading: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: AppColors.primary),
        ),
        text: 'Memuat cuaca...',
      );
    }
    // 2. Error
    if (provider.error != null) {
      return _StatusRow(
        leading:
            const Icon(Icons.cloud_off_outlined, color: AppColors.textGrey),
        text: provider.error!,
        actionLabel: 'Coba Lagi',
        onAction: provider.loadWeather,
      );
    }
    // 3. Kosong
    final weather = provider.weather;
    if (weather == null) {
      return _StatusRow(
        leading: const Icon(Icons.cloud_queue, color: AppColors.textGrey),
        text: 'Data cuaca belum tersedia',
        actionLabel: 'Muat',
        onAction: provider.loadWeather,
      );
    }
    // 4. Data
    return _WeatherData(weather: weather, provider: provider);
  }
}

class _WeatherData extends StatelessWidget {
  final Weather weather;
  final WeatherProvider provider;

  const _WeatherData({required this.weather, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(weatherIcon(weather.weatherCode),
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CUACA HARI INI • ${provider.locationName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey)),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${weather.temperature.round()}°C',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(weather.description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textGrey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: provider.loadWeather,
              tooltip: 'Muat ulang',
              icon: const Icon(Icons.refresh, color: AppColors.textGrey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
                icon: Icons.water_drop_outlined,
                label: 'Lembap ${weather.humidity}%'),
            _InfoChip(
                icon: Icons.air,
                label: 'Angin ${weather.windSpeed.round()} km/jam'),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyBox,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Widget leading;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StatusRow({
    required this.leading,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 13.5, color: AppColors.textGrey)),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
      ],
    );
  }
}