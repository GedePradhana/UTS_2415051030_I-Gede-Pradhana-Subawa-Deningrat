import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

void main() => runApp(const KontrakankuApp());

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