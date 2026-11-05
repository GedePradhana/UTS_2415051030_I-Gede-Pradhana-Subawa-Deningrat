import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import 'payment_tile.dart';

/// Daftar riwayat pembayaran. [limit] membatasi jumlah item yang tampil.
class PaymentHistoryList extends StatelessWidget {
  final int? limit;

  const PaymentHistoryList({super.key, this.limit});

  @override
  Widget build(BuildContext context) {
    final payments = context.watch<PaymentProvider>();
    final expenses = context.watch<ExpenseProvider>();

    final target = expenses.totalAmount ~/ payments.peopleCount;
    final all = payments.payments;
    final list = limit == null ? all : all.take(limit!).toList();

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text('Belum ada pembayaran tercatat',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey)),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < list.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          PaymentTile(
            payment: list[i],
            tenant: payments.tenantById(list[i].tenantId),
            settled: payments.paidUpTo(list[i]) >= target,
          ),
        ],
      ],
    );
  }
}