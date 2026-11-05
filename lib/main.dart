import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/expense_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/weather_provider.dart';
import 'repositories/expense_repository.dart';
import 'repositories/payment_repository.dart';
import 'repositories/weather_repository.dart';
import 'screens/main_shell.dart';
import 'services/expense_service.dart';
import 'services/payment_service.dart';
import 'services/weather_service.dart';
import 'theme/app_colors.dart';
import 'utils/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    runApp(const _MissingConfigApp());
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.key,
  );
  runApp(const KontrakankuApp());
}

class KontrakankuApp extends StatelessWidget {
  // Service bisa diganti (misalnya saat testing).
  final ExpenseService? expenseService;
  final PaymentService? paymentService;
  final WeatherService? weatherService;

  const KontrakankuApp({
    super.key,
    this.expenseService,
    this.paymentService,
    this.weatherService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(
              ExpenseRepository(expenseService ?? ExpenseService()))
            ..loadExpenses(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(
              PaymentRepository(paymentService ?? PaymentService()))
            ..loadAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
              WeatherRepository(weatherService ?? WeatherService()))
            ..loadWeather(),
        ),
      ],
      child: MaterialApp(
        title: 'Kontrakanku',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainShell(),
      ),
    );
  }
}

/// Ditampilkan jika env.json belum diisi.
class _MissingConfigApp extends StatelessWidget {
  const _MissingConfigApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Konfigurasi Supabase belum diisi.\n\n'
              'Buat file env.json (lihat env.example.json), lalu jalankan:\n'
              'flutter run --dart-define-from-file=env.json',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}