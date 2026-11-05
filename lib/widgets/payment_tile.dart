import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../models/tenant.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Satu baris riwayat pembayaran.
class PaymentTile extends StatelessWidget {
  final Payment payment;
  final Tenant? tenant;
  final bool settled; // true jika setelah pembayaran ini tagihan lunas

  const PaymentTile({
    super.key,
    required this.payment,
    required this.tenant,
    required this.settled,
  });

  @override
  Widget build(BuildContext context) {
    final isTransfer = payment.method == PaymentMethod.transfer;
    final name = tenant == null
        ? 'Penghuni'
        : '${tenant!.fullName} (Kamar ${tenant!.room})';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
                isTransfer
                    ? Icons.account_balance_outlined
                    : Icons.payments_outlined,
                color: AppColors.primary,
                size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 3),
                Text('${formatTanggal(payment.paidAt)} • ${payment.method.label}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${formatRupiah(payment.amount)}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (settled) ...[
                      const CircleAvatar(
                          radius: 3, backgroundColor: AppColors.primary),
                      const SizedBox(width: 5),
                    ],
                    Text(settled ? 'Lunas' : 'Dicatat',
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}