import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';
import '../utils/input_formatters.dart';
import '../widgets/category_selector.dart';
import '../widgets/form_app_bar.dart';
import '../widgets/split_summary_card.dart';

/// Membuka halaman Tambah Pengeluaran.
void openAddExpenseScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
  );
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.listrik;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = formatTanggalPanjang(_date);
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

    final success = await provider.addExpense(
      Expense(
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
        content: Text('Pengeluaran berhasil disimpan'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Gagal menyimpan pengeluaran. Coba lagi.'),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  InputDecoration _decoration({
    String? hint,
    Widget? prefixIcon,
    String? prefixText,
    TextStyle? prefixStyle,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      suffixIcon: suffixIcon,
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary, 1.5),
      errorBorder: border(const Color(0xFFEF4444)),
      focusedErrorBorder: border(const Color(0xFFEF4444), 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tenants = context.watch<PaymentProvider>().tenants;
    final amount = parseRupiah(_amountController.text) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const FormAppBar(title: 'Tambah Pengeluaran'),
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
                  _HeaderCard(people: tenants.length),
                  const SizedBox(height: 22),
                  _Label('Nama Pengeluaran',
                      trailing: 'Wajib diisi', trailingColor: AppColors.primary),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        _decoration(hint: 'Contoh: Token Listrik, Galon Aqua'),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Nama pengeluaran wajib diisi';
                      if (value.length < 3) return 'Minimal 3 karakter';
                      if (value.length > 60) return 'Maksimal 60 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const _Label('Kategori Pengeluaran'),
                  CategorySelector(
                    selected: _category,
                    onChanged: (c) => setState(() => _category = c),
                  ),
                  const SizedBox(height: 20),
                  const _Label('Nominal Pengeluaran (Rp)'),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsSeparatorInputFormatter()],
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                    decoration: _decoration(
                      hint: '0',
                      prefixText: 'Rp  ',
                      prefixStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                      suffixIcon: _amountController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _amountController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.cancel_outlined,
                                  color: AppColors.textGrey),
                            ),
                    ),
                    validator: (v) {
                      final value = parseRupiah(v ?? '');
                      if (value == null) return 'Nominal wajib diisi';
                      if (value <= 0) return 'Nominal harus lebih dari 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const _Label('Tanggal Transaksi'),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: _decoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF4B5563)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _Label('Keterangan',
                      trailing: 'Opsional', trailingColor: AppColors.textGrey),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        _decoration(hint: 'Catatan tambahan pengeluaran...'),
                    validator: (v) => (v ?? '').length > 200
                        ? 'Maksimal 200 karakter'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SplitSummaryCard(amount: amount, tenants: tenants),
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
                          : const Icon(Icons.check_circle_outline, size: 22),
                      label: Text(_saving ? 'Menyimpan...' : 'Simpan Pengeluaran'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int people;
  const _HeaderCard({required this.people});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.receipt_long_outlined,
                color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Catat Tagihan Kost',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text('Beban bersama dibagi rata ke $people penghuni',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final String? trailing;
  final Color? trailingColor;

  const _Label(this.text, {this.trailing, this.trailingColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
          ),
          if (trailing != null)
            Text(trailing!,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: trailingColor)),
        ],
      ),
    );
  }
}