import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/category_style.dart';
import '../utils/formatters.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final int people;
  final VoidCallback? onTap;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.people,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(expense.category.label);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(iconForExpense(expense),
                  color: style.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  const SizedBox(height: 3),
                  Text(
                      '${formatTanggal(expense.expenseDate)} • @${formatRupiah(expense.perPerson(people))}/org',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textGrey)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRupiah(expense.amount),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 3),
                const Text('Dibayar Kas',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}