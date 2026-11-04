import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const KontrakankuApp());

class KontrakankuApp extends StatelessWidget {
  const KontrakankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontrakanku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardScreen(),
    );
  }
}