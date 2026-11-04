import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard_app_bar.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DashboardAppBar(subtitle: title),
      body: Center(
        child: Text('Halaman $title segera dibuat',
            style: const TextStyle(color: AppColors.textGrey)),
      ),
    );
  }
}