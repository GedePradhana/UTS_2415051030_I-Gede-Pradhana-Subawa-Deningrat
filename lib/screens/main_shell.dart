import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/breakpoints.dart';
import 'dashboard_screen.dart';
import 'expense_list_screen.dart';
import 'payment_history_screen.dart';
import 'payment_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// Pindah tab dari widget turunan (misalnya tombol di Dashboard).
  static void selectTab(BuildContext context, int index) {
    context.findAncestorStateOfType<MainShellState>()?.selectTab(index);
  }

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    DashboardScreen(),
    ExpenseListScreen(),
    PaymentScreen(),
    PaymentHistoryScreen(),
  ];

  static const _labels = ['Dashboard', 'Pengeluaran', 'Pembayaran', 'Riwayat'];
  static const _icons = [
    Icons.dashboard_outlined,
    Icons.receipt_long_outlined,
    Icons.payments_outlined,
    Icons.history,
  ];

  void selectTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= Breakpoints.wide;
        final body = IndexedStack(index: _index, children: _pages);

        // Layout wide: NavigationRail di sisi kiri.
        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: selectTab,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
                  indicatorColor: AppColors.primarySoft,
                  selectedIconTheme:
                      const IconThemeData(color: AppColors.primary),
                  unselectedIconTheme:
                      const IconThemeData(color: Color(0xFF4B5563)),
                  selectedLabelTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                  unselectedLabelTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563)),
                  destinations: [
                    for (var i = 0; i < _labels.length; i++)
                      NavigationRailDestination(
                        icon: Icon(_icons[i]),
                        label: Text(_labels[i]),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                Expanded(child: body),
              ],
            ),
          );
        }

        // Layout compact: BottomNavigationBar.
        return Scaffold(
          body: body,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: selectTab,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: const Color(0xFF4B5563),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600),
              items: [
                for (var i = 0; i < _labels.length; i++)
                  BottomNavigationBarItem(
                      icon: Icon(_icons[i]), label: _labels[i]),
              ],
            ),
          ),
        );
      },
    );
  }
}