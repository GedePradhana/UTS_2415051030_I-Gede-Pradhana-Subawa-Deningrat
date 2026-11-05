import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Menampilkan dialog konfirmasi, lalu menghapus pengeluaran jika disetujui.
/// Setelah berhasil, kembali ke halaman utama.
Future<void> deleteExpenseWithConfirmation(
    BuildContext context, Expense expense) async {
  final provider = context.read<ExpenseProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => _DeleteDialog(expense: expense),
  );
  if (confirmed != true || expense.id == null) return;

  final success = await provider.deleteExpense(expense.id!);

  if (success) {
    navigator.popUntil((route) => route.isFirst);
    messenger.showSnackBar(const SnackBar(
      content: Text('Pengeluaran berhasil dihapus'),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  } else {
    messenger.showSnackBar(const SnackBar(
      content: Text('Gagal menghapus pengeluaran. Coba lagi.'),
      backgroundColor: Color(0xFFEF4444),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class _DeleteDialog extends StatelessWidget {
  final Expense expense;

  const _DeleteDialog({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline,
                  color: Color(0xFFDC2626), size: 28),
            ),
            const SizedBox(height: 16),
            const Text('Hapus Pengeluaran?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
            const SizedBox(height: 10),
            Text(
                'Pengeluaran "${expense.title}" sebesar ${formatRupiah(expense.amount)} akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, height: 1.5, color: AppColors.textGrey)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: AppColors.textDark,
                      side: const BorderSide(color: AppColors.border),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Ya, Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}