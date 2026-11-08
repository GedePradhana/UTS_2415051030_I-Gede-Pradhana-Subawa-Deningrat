import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/tenant.dart';
import '../providers/payment_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/form_app_bar.dart';
import '../widgets/form_helpers.dart';
import '../widgets/refreshable.dart';

/// Membuka halaman Kelola Penghuni.
void openTenantsScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const TenantsScreen()),
  );
}

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tenants = context.watch<PaymentProvider>().tenants;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const FormAppBar(title: 'Kelola Penghuni'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: RefreshableListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _SummaryCard(count: tenants.length),
              const SizedBox(height: 16),
              for (final t in tenants) ...[
                _TenantTile(
                  tenant: t,
                  onEdit: () => _showTenantForm(context, tenant: t),
                  onDelete: () => _confirmDelete(context, t, tenants.length),
                ),
                const SizedBox(height: 12),
              ],
              if (tenants.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Belum ada penghuni',
                        style: TextStyle(color: AppColors.textGrey)),
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _showTenantForm(context),
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 22),
                  label: const Text('Tambah Penghuni'),
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8F1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCFF0E1)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                          'Total beban dibagi rata ke semua penghuni. Menambah atau mengurangi penghuni akan mengubah tagihan tiap orang.',
                          style: TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: AppColors.textGrey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showTenantForm(BuildContext context, {Tenant? tenant}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _TenantFormSheet(tenant: tenant),
  );
}

Future<void> _confirmDelete(
    BuildContext context, Tenant tenant, int totalTenants) async {
  final messenger = ScaffoldMessenger.of(context);
  final provider = context.read<PaymentProvider>();

  if (totalTenants <= 1) {
    messenger.showSnackBar(const SnackBar(
      content: Text('Minimal harus ada 1 penghuni'),
      behavior: SnackBarBehavior.floating,
    ));
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Hapus Penghuni?',
          style: TextStyle(fontWeight: FontWeight.w800)),
      content: Text(
          '${tenant.fullName} (Kamar ${tenant.room}) dan seluruh riwayat pembayarannya akan dihapus permanen. Tagihan penghuni lain akan dihitung ulang.',
          style: const TextStyle(height: 1.5, color: AppColors.textGrey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          child: const Text('Ya, Hapus'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  final ok = await provider.deleteTenant(tenant.id);
  messenger.showSnackBar(SnackBar(
    content: Text(ok
        ? 'Penghuni berhasil dihapus'
        : 'Gagal menghapus penghuni. Coba lagi.'),
    backgroundColor: ok ? AppColors.primary : const Color(0xFFEF4444),
    behavior: SnackBarBehavior.floating,
  ));
}

class _SummaryCard extends StatelessWidget {
  final int count;
  const _SummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            child: const Icon(Icons.groups_outlined,
                color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count Penghuni • $count Kamar',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                const Text('Tagihan dibagi rata ke semua penghuni',
                    style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TenantTile extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TenantTile({
    required this.tenant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primarySoft,
            child: Text('${tenant.name[0]}${tenant.room}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
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
                        color: AppColors.greyBox,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Kamar ${tenant.room}',
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textGrey)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(tenant.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: Color(0xFF4B5563)),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline,
                size: 20, color: Color(0xFFDC2626)),
          ),
        ],
      ),
    );
  }
}

class _TenantFormSheet extends StatefulWidget {
  final Tenant? tenant;
  const _TenantFormSheet({this.tenant});

  @override
  State<_TenantFormSheet> createState() => _TenantFormSheetState();
}

class _TenantFormSheetState extends State<_TenantFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _roomController;
  bool _saving = false;

  bool get _isEdit => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tenant;
    final tenants = context.read<PaymentProvider>().tenants;
    final nextRoom =
        tenants.fold<int>(0, (max, x) => x.room > max ? x.room : max) + 1;

    _nameController = TextEditingController(text: t?.name ?? '');
    _fullNameController = TextEditingController(text: t?.fullName ?? '');
    _roomController =
        TextEditingController(text: (t?.room ?? nextRoom).toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullNameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PaymentProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final name = _nameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final room = int.parse(_roomController.text.trim());

    setState(() => _saving = true);

    final ok = _isEdit
        ? await provider.updateTenant(Tenant(
            id: widget.tenant!.id, name: name, fullName: fullName, room: room))
        : await provider.addTenant(name: name, fullName: fullName, room: room);

    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(
        content: Text(_isEdit
            ? 'Data penghuni berhasil diperbarui'
            : 'Penghuni berhasil ditambahkan'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Gagal menyimpan penghuni. Coba lagi.'),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PaymentProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(_isEdit ? 'Edit Penghuni' : 'Tambah Penghuni',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark)),
              const SizedBox(height: 18),
              const FormLabel('Nama Panggilan'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: formInputDecoration(hint: 'Contoh: Budi'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Nama panggilan wajib diisi';
                  if (value.length < 2) return 'Minimal 2 karakter';
                  if (value.length > 20) return 'Maksimal 20 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const FormLabel('Nama Lengkap'),
              TextFormField(
                controller: _fullNameController,
                textCapitalization: TextCapitalization.words,
                decoration: formInputDecoration(hint: 'Contoh: Budi Santoso'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Nama lengkap wajib diisi';
                  if (value.length < 3) return 'Minimal 3 karakter';
                  if (value.length > 40) return 'Maksimal 40 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const FormLabel('Nomor Kamar'),
              TextFormField(
                controller: _roomController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: formInputDecoration(hint: 'Contoh: 4'),
                validator: (v) {
                  final room = int.tryParse(v?.trim() ?? '');
                  if (room == null) return 'Nomor kamar wajib diisi';
                  if (room < 1) return 'Nomor kamar minimal 1';
                  if (provider.isRoomTaken(room,
                      exceptId: widget.tenant?.id)) {
                    return 'Kamar $room sudah dipakai penghuni lain';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withAlpha(153),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    textStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}