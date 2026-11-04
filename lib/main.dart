
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rdycrwvpoylyqwhpfkrb.supabase.co',
    anonKey: 'sb_publishable_9aBM_C0y9b4D-gxfWuAB1w_V7J_6Th3',
  );

  runApp(const KontrakankuApp());
}

class KontrakankuApp extends StatelessWidget {
  const KontrakankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(ExpenseRepository(ExpenseService()))
            ..loadExpenses(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(PaymentRepository(PaymentService()))
            ..loadAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(WeatherRepository(WeatherService()))
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
