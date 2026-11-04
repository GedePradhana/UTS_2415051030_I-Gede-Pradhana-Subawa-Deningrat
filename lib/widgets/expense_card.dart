import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/category_style.dart';
import '../utils/formatters.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final int people;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.people,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(expense.category.label);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(iconForExpense(expense), color: style.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: style.background,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(expense.category.label,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: style.color)),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text('• ${formatTanggal(expense.expenseDate)}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12.5, color: AppColors.textGrey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(expense.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.groups_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text('@${formatRupiah(expense.perPerson(people))} / orang',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatRupiah(expense.amount),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SquareButton(icon: Icons.edit_outlined, onTap: onEdit),
                      const SizedBox(width: 8),
                      _SquareButton(icon: Icons.chevron_right, onTap: onTap),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _SquareButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF4B5563)),
      ),
    );
  }
}