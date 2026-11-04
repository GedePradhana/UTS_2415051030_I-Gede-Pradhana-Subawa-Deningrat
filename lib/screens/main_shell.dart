import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'coming_soon_screen.dart';
import 'dashboard_screen.dart';
import 'expense_list_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    DashboardScreen(),
    ExpenseListScreen(),
    ComingSoonScreen(title: 'Pembayaran'),
    ComingSoonScreen(title: 'Riwayat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: const Color(0xFF4B5563),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined), label: 'Pengeluaran'),
            BottomNavigationBarItem(
                icon: Icon(Icons.payments_outlined), label: 'Pembayaran'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Riwayat'),
          ],
        ),
      ),
    );
  }
}