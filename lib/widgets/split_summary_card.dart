import 'package:flutter/material.dart';
import '../models/tenant.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Ringkasan pembagian biaya rata untuk semua penghuni.
class SplitSummaryCard extends StatelessWidget {
  final int amount;
  final List<Tenant> tenants;

  const SplitSummaryCard({
    super.key,
    required this.amount,
    required this.tenants,
  });

  String get _names {
    final n = tenants.map((t) => t.name).toList();
    if (n.isEmpty) return 'penghuni';
    if (n.length == 1) return n.first;
    return '${n.sublist(0, n.length - 1).join(', ')}, dan ${n.last}';
  }

  @override
  Widget build(BuildContext context) {
    final people = tenants.isEmpty ? 1 : tenants.length;
    final perPerson = amount ~/ people;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCFF0E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.groups_outlined,
                  color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Bagi Rata Otomatis',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7F3E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$people Penghuni',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCFF0E1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Beban Tiap Penghuni',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(formatRupiah(perPerson),
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                    '${formatRupiah(amount).replaceFirst('Rp', '')} / $people',
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Penambahan Tagihan Aktif:',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < tenants.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCFF0E1)),
                    ),
                    child: Column(
                      children: [
                        Text(tenants[i].name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text('+${formatRupiah(perPerson)}',
                            style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Biaya ini otomatis menambah tagihan $_names secara real-time di sistem kost.',
                    style: const TextStyle(
                        fontSize: 13, height: 1.4, color: AppColors.textGrey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}