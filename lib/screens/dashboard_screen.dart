import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/expense_tile.dart';
import '../widgets/refreshable.dart';
import '../widgets/section_header.dart';
import '../widgets/summary_card.dart';
import '../widgets/state_views.dart';
import '../widgets/tenant_card.dart';
import '../widgets/weather_card.dart';
import 'add_expense_screen.dart';
import 'expense_detail_screen.dart';
import 'main_shell.dart';
import 'tenants_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>();
    final payments = context.watch<PaymentProvider>();

    final loading = expenses.isLoading || payments.isLoading;
    final error = expenses.error ?? payments.error;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DashboardAppBar(),
      body: loading
          ? const LoadingView()
          : error != null
              ? ErrorView(
                  message: error,
                  onRetry: () {
                    expenses.loadExpenses();
                    payments.loadAll();
                  },
                )
              : _DashboardContent(expenses: expenses, payments: payments),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final ExpenseProvider expenses;
  final PaymentProvider payments;

  const _DashboardContent({required this.expenses, required this.payments});

  @override
  Widget build(BuildContext context) {
    final total = expenses.totalAmount;
    final people = payments.peopleCount;
    final target = total ~/ people;
    final latest = expenses.latestExpenses;

    return RefreshableScroll(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Greeting(people: people),
              const SizedBox(height: 20),
              const WeatherCard(),
              const SizedBox(height: 20),
              SummaryCard(
                  total: total,
                  collected: payments.totalCollected,
                  people: people),
              const SizedBox(height: 20),
              const _ActionButtons(),
              const SizedBox(height: 28),
              SectionHeader(
                  title: 'Iuran Penghuni Kontrakan',
                  chipLabel: '$people Kamar',
                  actionLabel: 'Detail',
                  onAction: () => openTenantsScreen(context)),
              const SizedBox(height: 14),
              for (final t in payments.tenants) ...[
                TenantCard(
                    name: t.name,
                    room: t.room,
                    target: target,
                    paid: payments.paidBy(t.id)),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 14),
              SectionHeader(
                  title: 'Pengeluaran Terbaru',
                  showDot: true,
                  actionLabel: 'Lihat Semua',
                  onAction: () {
                    final expenses = context.read<ExpenseProvider>();
                    expenses.selectCategory('Semua');
                    expenses.selectMonth(null);
                    MainShell.selectTab(context, 1);
                  }),
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
                      ExpenseTile(
                        expense: latest[i],
                        people: people,
                        onTap: () => openExpenseDetail(context, latest[i]),
                      ),
                      if (i < latest.length - 1)
                        const Divider(height: 1, color: AppColors.border),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final int people;
  const _Greeting({required this.people});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text('Catatan Kas Bersama ($people Penghuni)',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textGrey)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text('Halo, Pengelola Kontrakan 👋',
            style: TextStyle(
                fontSize: 22,
                height: 1.25,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark)),
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
            onPressed: () => openAddExpenseScreen(context),
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: const Text('Beban'),
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
            onPressed: () => MainShell.selectTab(context, 2),
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