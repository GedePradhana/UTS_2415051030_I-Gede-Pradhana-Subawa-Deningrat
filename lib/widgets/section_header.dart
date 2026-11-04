import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final String? chipLabel;
  final bool showDot;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    this.chipLabel,
    this.showDot = false,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ),
        if (showDot) ...[
          const SizedBox(width: 8),
          const CircleAvatar(radius: 3.5, backgroundColor: AppColors.primary),
        ],
        if (chipLabel != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.greyBox,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(chipLabel!,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textGrey)),
          ),
        ],
        const Spacer(),
        GestureDetector(
          onTap: onAction,
          child: Text(actionLabel,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ),
      ],
    );
  }
}