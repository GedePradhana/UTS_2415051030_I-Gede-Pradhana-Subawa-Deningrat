import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../utils/breakpoints.dart';
import '../utils/formatters.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/expense_card.dart';

const _categories = ['Semua', 'Listrik', 'Air', 'Gas', 'Lainnya'];
const _people = 3;

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String _selected = 'Semua';

  @override
  Widget build(BuildContext context) {
    final filtered = _selected == 'Semua'
        ? dummyExpenses
        : dummyExpenses.where((e) => e.category.label == _selected).toList();
    final total = dummyExpenses.fold<int>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const DashboardAppBar(subtitle: 'Pengeluaran'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add, size: 26),
        label: const Text('Catat Pengeluaran',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Compact: 1 kolom. Wide: 2 kolom.
          final isWide = constraints.maxWidth >= Breakpoints.wideContent;
          final maxWidth = isWide ? 1000.0 : 640.0;
          final available = constraints.maxWidth < maxWidth
              ? constraints.maxWidth
              : maxWidth;
          const padding = 16.0;
          const gap = 14.0;
          final contentWidth = available - padding * 2;
          final cardWidth = isWide ? (contentWidth - gap) / 2 : contentWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(padding, 20, padding, 100),
                children: [
                  const _Header(),
                  const SizedBox(height: 18),
                  _TotalCard(total: total, count: dummyExpenses.length),
                  const SizedBox(height: 16),
                  CategoryFilterBar(
                    categories: _categories,
                    selected: _selected,
                    onSelected: (c) => setState(() => _selected = c),
                  ),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('Belum ada pengeluaran untuk kategori ini',
                            style: TextStyle(color: AppColors.textGrey)),
                      ),
                    ),
                  Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final e in filtered)
                        SizedBox(
                          width: cardWidth,
                          child: ExpenseCard(expense: e, people: _people),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daftar Pengeluaran',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
              SizedBox(height: 6),
              Text('Kelola tagihan bersama & iuran kontrakan',
                  style: TextStyle(
                      fontSize: 14.5, height: 1.35, color: AppColors.textGrey)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month_outlined,
                  size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Okt\n2024',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down,
                  size: 20, color: AppColors.textGrey),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int total;
  final int count;
  const _TotalCard({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE3F7EE), Colors.white],
          stops: [0.0, 0.55],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TOTAL PENGELUARAN',
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey)),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(formatRupiah(total),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$count Catatan',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
              const SizedBox(height: 8),
              const Text('3 Penghuni Aktif',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }
}