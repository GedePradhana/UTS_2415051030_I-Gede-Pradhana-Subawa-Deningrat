import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/weather_provider.dart';

/// Memuat ulang semua data (pengeluaran, penghuni, pembayaran, cuaca)
/// tanpa menutup layar yang sedang tampil.
Future<void> refreshAll(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);

  final results = await Future.wait([
    context.read<ExpenseProvider>().refresh(),
    context.read<PaymentProvider>().refresh(),
    context.read<WeatherProvider>().refresh(),
  ]);

  if (results.contains(false)) {
    messenger.showSnackBar(const SnackBar(
      content: Text('Gagal memuat ulang sebagian data. Periksa koneksi internet.'),
      backgroundColor: Color(0xFFEF4444),
      behavior: SnackBarBehavior.floating,
    ));
  }
}