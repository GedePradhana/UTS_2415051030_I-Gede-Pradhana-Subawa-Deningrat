import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/tenant.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';
import '../utils/formatters.dart';
import '../utils/input_formatters.dart';
import '../widgets/category_selector.dart';
import '../widgets/form_app_bar.dart';
import '../widgets/form_helpers.dart';

/// Membuka halaman Edit Pengeluaran.
void openEditExpense(BuildContext context, Expense expense) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => EditExpenseScreen(expense: expense)),
  );
}

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;

  late ExpenseCategory _category;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _category = e.category;
    _date = e.expenseDate;
    _nameController = TextEditingController(text: e.title);
    _amountController = TextEditingController(
        text: formatRupiah(e.amount).replaceFirst('Rp', ''));
    _dateController = TextEditingController(text: formatTanggalPanjang(_date));
    _noteController = TextEditingController(text: e.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateController.text = formatTanggalPanjang(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ExpenseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final note = _noteController.text.trim();

    setState(() => _saving = true);

    final success = await provider.updateExpense(
      Expense(
        id: widget.expense.id,
        title: _nameController.text.trim(),
        category: _category,
        amount: parseRupiah(_amountController.text)!,
        expenseDate: _date,
        note: note.isEmpty ? null : note,
      ),
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      navigator.pop();
      messenger.showSnackBar(const SnackBar(
        content: Text('Pengeluaran berhasil diperbarui'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Gagal memperbarui pengeluaran. Coba lagi.'),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenants = context.watch<PaymentProvider>().tenants;
    final amount = parseRupiah(_amountController.text) ?? 0;
    final idLabel =
        'EXP-${(widget.expense.id ?? 0).toString().padLeft(3, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const FormAppBar(title: 'Edit Pengeluaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Status Formulir: Terisi',
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textGrey)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                size: 16, color: Color(0xFFDC2626)),
                            SizedBox(width: 6),
                            Text('Hapus',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFDC2626))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _IdCard(idLabel: idLabel),
                  const SizedBox(height: 22),
                  const FormLabel('Nama Pengeluaran'),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: formInputDecoration(
                      hint: 'Contoh: Token Listrik, Galon Aqua',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined,
                          color: Color(0xFF4B5563)),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Nama pengeluaran wajib diisi';
                      if (value.length < 3) return 'Minimal 3 karakter';
                      if (value.length > 60) return 'Maksimal 60 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const FormLabel('Kategori Pengeluaran'),
                  CategorySelector(
                    selected: _category,
                    onChanged: (c) => setState(() => _category = c),
                  ),
                  const SizedBox(height: 20),
                  const FormLabel('Nominal Pengeluaran'),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsSeparatorInputFormatter()],
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                    decoration: formInputDecoration(
                      hint: '0',
                      prefixText: 'Rp  ',
                      prefixStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                      suffixIcon: amount > 0
                          ? const Icon(Icons.check_circle_outline,
                              color: AppColors.primary)
                          : null,
                    ),
                    validator: (v) {
                      final value = parseRupiah(v ?? '');
                      if (value == null) return 'Nominal wajib diisi';
                      if (value <= 0) return 'Nominal harus lebih dari 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const FormLabel('Tanggal Transaksi'),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: formInputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF4B5563)),
                      suffixIcon: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textGrey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const FormLabel('Keterangan / Catatan Tambahan'),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        formInputDecoration(hint: 'Catatan tambahan...'),
                    validator: (v) => (v ?? '').length > 200
                        ? 'Maksimal 200 karakter'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  _RecalcCard(amount: amount, tenants: tenants),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Icon(Icons.save_outlined, size: 22),
                      label: Text(
                          _saving ? 'Menyimpan...' : 'Perbarui Pengeluaran'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                      child: const Text('Batal',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  final String idLabel;
  const _IdCard({required this.idLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tag, color: Color(0xFF6366F1), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('IDENTIFIKASI ENTRI',
                    style: TextStyle(
                        fontSize: 11.5,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey)),
                const SizedBox(height: 2),
                const Text('Mengedit data pengeluaran ID:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Text(idLabel,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
              ],
            ),
          ),
          const CircleAvatar(radius: 5, backgroundColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _RecalcCard extends StatelessWidget {
  final int amount;
  final List<Tenant> tenants;

  const _RecalcCard({required this.amount, required this.tenants});

  @override
  Widget build(BuildContext context) {
    final people = tenants.isEmpty ? 1 : tenants.length;
    final perPerson = amount ~/ people;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCFF0E1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7F3E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.groups_outlined,
                    size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Kalkulasi Ulang Pembagian Biaya',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFEBD6)),
                ),
                child: Text('Otomatis Terbagi $people',
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCFF0E1)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Beban Per Orang',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textGrey)),
                ),
                Text(formatRupiah(perPerson),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
                const Text(' / orang',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < tenants.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _TenantShare(
                tenant: tenants[i], amount: perPerson, isMain: i == 0),
          ],
        ],
      ),
    );
  }
}

class _TenantShare extends StatelessWidget {
  final Tenant tenant;
  final int amount;
  final bool isMain;

  const _TenantShare({
    required this.tenant,
    required this.amount,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCFF0E1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                isMain ? const Color(0xFFE0E7FF) : AppColors.greyBox,
            child: Text(tenant.name[0],
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isMain
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF4B5563))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tenant.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    CircleAvatar(
                        radius: 3,
                        backgroundColor: isMain
                            ? AppColors.primary
                            : const Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(isMain ? 'Pembayar Utama' : 'Beban Patungan',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isMain
                                  ? AppColors.primary
                                  : AppColors.textGrey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(formatRupiah(amount),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}