import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/tenant.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../theme/category_style.dart';
import '../utils/formatters.dart';
import '../widgets/form_app_bar.dart';
import 'edit_expense_screen.dart';

/// Membuka halaman Detail Pengeluaran sambil membawa data pengeluaran.
void openExpenseDetail(BuildContext context, Expense expense) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ExpenseDetailScreen(expense: expense)),
  );
}

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    // Ambil data terbaru dari provider (agar ikut berubah setelah diedit).
    final current =
        context.watch<ExpenseProvider>().findById(expense.id) ?? expense;
    final tenants = context.watch<PaymentProvider>().tenants;
    final people = tenants.isEmpty ? 1 : tenants.length;
    final perPerson = current.perPerson(people);
    final recordedBy =
        tenants.isEmpty ? 'Pengelola' : '${tenants.first.name} (Pengelola)';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const FormAppBar(title: 'Detail Pengeluaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('TRANSAKSI KOSAN',
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey)),
                    ),
                    _SquareIconButton(
                        icon: Icons.edit_outlined,
                        onTap: () => openEditExpense(context, current)),
                  ],
                ),
                const SizedBox(height: 12),
                _MainCard(expense: current, recordedBy: recordedBy),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.pie_chart_outline,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Pembagian Biaya ($people Orang)',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.greyBox,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${formatRupiah(perPerson)} / orang',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < tenants.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        _ShareRow(
                          tenant: tenants[i],
                          amount: perPerson,
                          people: people,
                          isManager: i == 0,
                        ),
                      ],
                      if (tenants.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Belum ada data penghuni',
                              style: TextStyle(color: AppColors.textGrey)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => openEditExpense(context, current),
                    icon: const Icon(Icons.edit_note, size: 24),
                    label: const Text('Edit Pengeluaran'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 22),
                    label: const Text('Hapus Pengeluaran'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.border),
                      textStyle: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  final Expense expense;
  final String recordedBy;

  const _MainCard({required this.expense, required this.recordedBy});

  @override
  Widget build(BuildContext context) {
    final style = categoryStyle(expense.category.label);
    final note = expense.note;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE3F7EE), Colors.white],
          stops: [0.0, 0.5],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(style.icon, size: 16, color: style.color),
                    const SizedBox(width: 6),
                    Text(expense.category.label,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: style.color)),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EEF0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    color: AppColors.textGrey, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(expense.title,
              style: const TextStyle(
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark)),
          const SizedBox(height: 18),
          const Text('TOTAL BIAYA DIKELUARKAN',
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(formatRupiah(expense.amount),
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoBox(
                    icon: Icons.calendar_today_outlined,
                    label: 'Tanggal',
                    value: formatTanggal(expense.expenseDate)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBox(
                    icon: Icons.person_outline,
                    label: 'Dicatat Oleh',
                    value: recordedBy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sticky_note_2_outlined,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Keterangan / Catatan',
                          style: TextStyle(
                              fontSize: 12.5, color: AppColors.textGrey)),
                      const SizedBox(height: 4),
                      Text(
                          (note == null || note.isEmpty)
                              ? 'Tidak ada keterangan.'
                              : note,
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: AppColors.textDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textGrey)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  final Tenant tenant;
  final int amount;
  final int people;
  final bool isManager;

  const _ShareRow({
    required this.tenant,
    required this.amount,
    required this.people,
    required this.isManager,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                isManager ? AppColors.primarySoft : AppColors.greyBox,
            child: Text('${tenant.name[0]}${tenant.room}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isManager
                        ? AppColors.primary
                        : const Color(0xFF4B5563))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(tenant.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('Kamar ${tenant.room}',
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textGrey)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (isManager)
                  const Row(
                    children: [
                      CircleAvatar(
                          radius: 3.5, backgroundColor: AppColors.primary),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text('Beban pribadi (Pengelola)',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ),
                    ],
                  )
                else
                  const Text('Masuk ke tagihan bulanan',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatRupiah(amount),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('Porsi 1/$people',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 20, color: AppColors.textDark),
      ),
    );
  }
}