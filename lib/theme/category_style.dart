import 'package:flutter/material.dart';
import 'app_colors.dart';

class CategoryStyle {
  final Color color;
  final Color background;
  final IconData icon;

  const CategoryStyle(this.color, this.background, this.icon);
}

CategoryStyle categoryStyle(String category) {
  switch (category) {
    case 'Listrik':
      return const CategoryStyle(
          AppColors.orangeDark, AppColors.orangeSoft, Icons.bolt);
    case 'Air':
      return const CategoryStyle(
          AppColors.blue, AppColors.blueSoft, Icons.water_drop_outlined);
    case 'Gas':
      return const CategoryStyle(Color(0xFFEF4444), Color(0xFFFEE2E2),
          Icons.local_fire_department_outlined);
    default:
      return const CategoryStyle(
          AppColors.primary, AppColors.primarySoft, Icons.more_horiz);
  }
}