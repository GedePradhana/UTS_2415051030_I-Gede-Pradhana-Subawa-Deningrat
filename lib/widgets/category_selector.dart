import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/category_style.dart';

const _order = [
  ExpenseCategory.air,
  ExpenseCategory.listrik,
  ExpenseCategory.gas,
  ExpenseCategory.lainnya,
];

/// Pilihan kategori pengeluaran (4 kotak).
class CategorySelector extends StatelessWidget {
  final ExpenseCategory selected;
  final ValueChanged<ExpenseCategory> onChanged;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _order.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _Option(
              category: _order[i],
              isSelected: _order[i] == selected,
              onTap: () => onChanged(_order[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final ExpenseCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _Option({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? Colors.white : const Color(0xFF4B5563);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 68,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(categoryStyle(category.label).icon, size: 22, color: fg),
            const SizedBox(height: 6),
            Text(category.label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: fg)),
          ],
        ),
      ),
    );
  }
}