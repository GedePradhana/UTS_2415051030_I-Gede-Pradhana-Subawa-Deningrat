import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/payment_history_list.dart';
import '../widgets/state_views.dart';

/// Tab "Riwayat": seluruh pembayaran penghuni.
class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>();
    final payments = context.watch<PaymentProvider>();

    final loading = expenses.isLoading || payments.isLoading;
    final error = expenses.error ?? payments.error;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const DashboardAppBar(subtitle: 'Riwayat'),
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Riwayat Transaksi',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text(
                              '${payments.payments.length} pembayaran • Terkumpul ${formatRupiah(payments.totalCollected)}',
                              style: const TextStyle(
                                  fontSize: 13.5, color: AppColors.textGrey)),
                          const SizedBox(height: 16),
                          const PaymentHistoryList(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}