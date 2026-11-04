import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/tenant.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/expense_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/summary_card.dart';
import '../widgets/tenant_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  int _paidBy(Tenant t) => dummyPayments
      .where((p) => p.tenantId == t.id)
      .fold<int>(0, (sum, p) => sum + p.amount);

  @override
  Widget build(BuildContext context) {
    final total = dummyExpenses.fold<int>(0, (sum, e) => sum + e.amount);
    final people = dummyTenants.length;
    final target = total ~/ people;
    final collected = dummyPayments.fold<int>(0, (sum, p) => sum + p.amount);
    final latest = ([...dummyExpenses]
          ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate)))
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Greeting(),
                const SizedBox(height: 20),
                SummaryCard(
                    total: total, collected: collected, people: people),
                const SizedBox(height: 20),
                const _ActionButtons(),
                const SizedBox(height: 28),
                SectionHeader(
                    title: 'Iuran Penghuni Kontrakan',
                    chipLabel: '$people Kamar',
                    actionLabel: 'Detail'),
                const SizedBox(height: 14),
                for (final t in dummyTenants) ...[
                  TenantCard(
                      name: t.name,
                      room: t.room,
                      target: target,
                      paid: _paidBy(t)),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 14),
                const SectionHeader(
                    title: 'Pengeluaran Terbaru',
                    showDot: true,
                    actionLabel: 'Lihat Semua'),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < latest.length; i++) ...[
                        ExpenseTile(expense: latest[i], people: people),
                        if (i < latest.length - 1)
                          const Divider(height: 1, color: AppColors.border),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _TipBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text('Catatan Kas Bersama (3 Penghuni)',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textGrey)),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text('Halo, Pengelola Kontrakan 👋',
                  style: TextStyle(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: const Text('+ Beban'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(54),
              textStyle:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.payments_outlined,
                size: 22, color: AppColors.primary),
            label: const Text('Catat Bayar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textDark,
              side: const BorderSide(color: AppColors.border),
              minimumSize: const Size.fromHeight(54),
              textStyle:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class _TipBox extends StatelessWidget {
  const _TipBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCFF0E1)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
                'Total kas dikelola mandiri. Pembayaran oleh anak kontrakan otomatis memotong sisa tunggakan kamar.',
                style: TextStyle(
                    fontSize: 13.5, height: 1.4, color: AppColors.textGrey)),
          ),
        ],
      ),
    );
  }
}