import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/payment.dart';
import '../models/tenant.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../utils/compact_format.dart';
import '../utils/date_format.dart';
import '../utils/formatters.dart';
import '../utils/input_formatters.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/form_helpers.dart';
import '../widgets/payment_history_list.dart';
import '../widgets/refreshable.dart';
import '../widgets/state_views.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>();
    final payments = context.watch<PaymentProvider>();

    final loading = expenses.isLoading || payments.isLoading;
    final error = expenses.error ?? payments.error;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const DashboardAppBar(subtitle: 'Pembayaran'),
      body: loading
          ? const LoadingView()
          : error != null
              ? ErrorView(
                  message: error,
                  onRetry: () {
                    expenses.loadExpenses();
                    payments.loadAll();
                  },
                )
              : RefreshableScroll(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pembayaran & Riwayat',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const CircleAvatar(
                                  radius: 3.5,
                                  backgroundColor: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                  '${payments.tenants.length} Penghuni Kontrakan Aktif',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textGrey)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _SegmentedTabs(
                            selected: _tab,
                            onChanged: (i) => setState(() => _tab = i),
                          ),
                          const SizedBox(height: 16),
                          if (_tab == 0)
                            const _RecordPaymentTab()
                          else
                            const _HistoryTab(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _SegmentedTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const labels = ['Catat Pembayaran', 'Riwayat Transaksi'];
    const icons = [Icons.edit_note, Icons.receipt_long_outlined];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: i == selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: i == selected
                        ? Border.all(color: AppColors.border)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[i],
                          size: 18,
                          color: i == selected
                              ? AppColors.primary
                              : AppColors.textGrey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(labels[i],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: i == selected
                                    ? AppColors.primary
                                    : AppColors.textGrey)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    final count = context.watch<PaymentProvider>().payments.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Riwayat Transaksi',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ),
            Text('$count Tercatat',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        const PaymentHistoryList(),
      ],
    );
  }
}

class _RecordPaymentTab extends StatefulWidget {
  const _RecordPaymentTab();

  @override
  State<_RecordPaymentTab> createState() => _RecordPaymentTabState();
}

class _RecordPaymentTabState extends State<_RecordPaymentTab> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  int? _selectedId;
  PaymentMethod _method = PaymentMethod.transfer;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save(Tenant tenant) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PaymentProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final amount = parseRupiah(_amountController.text)!;

    setState(() => _saving = true);

    final success = await provider.addPayment(
      Payment(
        tenantId: tenant.id,
        amount: amount,
        method: _method,
        paidAt: _date,
      ),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      _amountController.clear();
      _formKey.currentState?.reset();
      messenger.showSnackBar(SnackBar(
        content: Text('Pembayaran ${tenant.name} berhasil dicatat'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Gagal menyimpan pembayaran. Coba lagi.'),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>();
    final payments = context.watch<PaymentProvider>();

    final target = expenses.totalAmount ~/ payments.peopleCount;
    int remainingOf(Tenant t) => target - payments.paidBy(t.id);
    final unpaid = payments.tenants.where((t) => remainingOf(t) > 0).toList();

    final selected = unpaid.isEmpty
        ? null
        : unpaid.firstWhere((t) => t.id == _selectedId,
            orElse: () => unpaid.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selected == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Semua penghuni sudah lunas untuk total beban saat ini.',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textGrey)),
                ),
              ],
            ),
          )
        else
          _buildForm(selected, unpaid, remainingOf(selected), remainingOf),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text('Riwayat Pembayaran Terbaru',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ),
            Text('${payments.payments.length} Tercatat',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        const PaymentHistoryList(limit: 3),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transparansi Keuangan Bersama',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    SizedBox(height: 2),
                    Text(
                        'Setiap mutasi terekam otomatis dan dapat diaudit seluruh anggota kontrakan.',
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm(Tenant selected, List<Tenant> unpaid, int remaining,
      int Function(Tenant) remainingOf) {
    final amount = parseRupiah(_amountController.text) ?? 0;
    final after = (remaining - amount).clamp(0, remaining);
    final willBeSettled = amount > 0 && after == 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Pilih Penghuni',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                ),
                Flexible(
                  child: Text(
                      '${unpaid.map((t) => 'Kamar ${t.room}').join(' & ')} Menunggak',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.orange)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < unpaid.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _TenantOption(
                      tenant: unpaid[i],
                      remaining: remainingOf(unpaid[i]),
                      isSelected: unpaid[i].id == selected.id,
                      onTap: () {
                        setState(() => _selectedId = unpaid[i].id);
                        _amountController.clear();
                        _formKey.currentState?.reset();
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.orangeSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pending_actions_outlined,
                        color: AppColors.orange, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sisa Hutang Berjalan',
                            style: TextStyle(
                                fontSize: 12.5, color: AppColors.textGrey)),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                              formatRupiah(remaining).replaceFirst('Rp', 'Rp '),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.orangeSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Belum Lunas',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orangeDark)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text('Nominal Pembayaran',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151))),
                ),
                const Text('Bayar Sebagian Aktif',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsSeparatorInputFormatter()],
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              decoration: formInputDecoration(
                hint: '0',
                prefixText: 'Rp  ',
                prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textGrey),
              ),
              validator: (v) {
                final value = parseRupiah(v ?? '');
                if (value == null) return 'Nominal wajib diisi';
                if (value <= 0) return 'Nominal harus lebih dari 0';
                if (value > remaining) {
                  return 'Melebihi sisa tagihan (${formatRupiah(remaining)})';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const FormLabel('Metode Pembayaran'),
            Row(
              children: [
                for (var i = 0; i < PaymentMethod.values.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _MethodOption(
                      method: PaymentMethod.values[i],
                      isSelected: PaymentMethod.values[i] == _method,
                      onTap: () =>
                          setState(() => _method = PaymentMethod.values[i]),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.textGrey),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Tanggal Pembayaran',
                          style: TextStyle(
                              fontSize: 13.5, color: AppColors.textGrey)),
                    ),
                    Text(formatTanggalPanjang(_date),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Simulasi Sisa Saldo',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textGrey)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: willBeSettled
                              ? AppColors.primarySoft
                              : AppColors.orangeSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                            willBeSettled ? 'Akan Lunas' : 'Masih Belum Lunas',
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: willBeSettled
                                    ? AppColors.primary
                                    : AppColors.orangeDark)),
                      ),
                    ],
                  ),
                  const Divider(height: 22, color: AppColors.border),
                  _SimRow(
                      label: 'Hutang Awal:',
                      value: formatRupiah(remaining).replaceFirst('Rp', 'Rp ')),
                  const SizedBox(height: 8),
                  _SimRow(
                      label: 'Nominal Bayar:',
                      value:
                          '- ${formatRupiah(amount).replaceFirst('Rp', 'Rp ')}',
                      valueColor: AppColors.primary),
                  const Divider(height: 22, color: AppColors.border),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Sisa Tagihan Menjadi:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                      ),
                      Text(formatRupiah(after).replaceFirst('Rp', 'Rp '),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: after == 0
                                  ? AppColors.primary
                                  : AppColors.orange)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : () => _save(selected),
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined, size: 22),
                label: Text(_saving ? 'Menyimpan...' : 'Simpan Pembayaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
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
    );
  }
}

class _TenantOption extends StatelessWidget {
  final Tenant tenant;
  final int remaining;
  final bool isSelected;
  final VoidCallback onTap;

  const _TenantOption({
    required this.tenant,
    required this.remaining,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(tenant.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                ),
                Icon(
                    isSelected
                        ? Icons.check_circle_outline
                        : Icons.check_circle_outline,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFD1D5DB)),
              ],
            ),
            const SizedBox(height: 2),
            Text('Kamar ${tenant.room}',
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                      radius: 3, backgroundColor: AppColors.orange),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(formatRupiahCompact(remaining),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orangeDark)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodOption extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodOption({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : const Color(0xFF4B5563);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFFAF5) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                method == PaymentMethod.transfer
                    ? Icons.account_balance_outlined
                    : Icons.payments_outlined,
                size: 20,
                color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(method.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SimRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textGrey)),
        ),
        Text(value,
            style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textDark)),
      ],
    );
  }
}