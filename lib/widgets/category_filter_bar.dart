import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/category_style.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isSelected = cat == selected;
          final isAll = cat == 'Semua';
          final style = categoryStyle(cat);
          final fg = isSelected ? Colors.white : const Color(0xFF4B5563);

          return GestureDetector(
            onTap: () => onSelected(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  if (!isAll) ...[
                    Icon(style.icon,
                        size: 18, color: isSelected ? Colors.white : style.color),
                    const SizedBox(width: 6),
                  ],
                  Text(cat,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: fg)),
                  if (isAll && isSelected) ...[
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.white),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}