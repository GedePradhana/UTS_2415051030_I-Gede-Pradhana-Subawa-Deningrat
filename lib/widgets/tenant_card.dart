import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class TenantCard extends StatelessWidget {
  final String name;
  final int room;
  final int target;
  final int paid;

  const TenantCard({
    super.key,
    required this.name,
    required this.room,
    required this.target,
    required this.paid,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = target - paid;
    final lunas = remaining <= 0;
    final accent = lunas ? AppColors.primary : AppColors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: lunas ? AppColors.primarySoft : AppColors.orangeSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bed_outlined, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text('Kamar $room • Target ${formatRupiah(target)}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(lunas: lunas),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.greyBox,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: 'Terbayar: ',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark),
                      children: [
                        TextSpan(
                          text: formatRupiah(paid),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: lunas
                                  ? AppColors.primary
                                  : AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  lunas ? 'Sisa: Rp0' : 'Kurang ${formatRupiah(remaining)}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: lunas ? FontWeight.w500 : FontWeight.w700,
                      color: lunas ? AppColors.textGrey : AppColors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool lunas;
  const _StatusBadge({required this.lunas});

  @override
  Widget build(BuildContext context) {
    final color = lunas ? AppColors.primary : AppColors.orangeDark;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 84),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: lunas ? AppColors.primarySoft : AppColors.orangeSoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: lunas ? const Color(0xFFBFEBD6) : const Color(0xFFFCE7A6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3, backgroundColor: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(lunas ? 'LUNAS' : 'BELUM LUNAS',
                  style: TextStyle(
                      fontSize: 11,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ),
          ],
        ),
      ),
    );
  }
}