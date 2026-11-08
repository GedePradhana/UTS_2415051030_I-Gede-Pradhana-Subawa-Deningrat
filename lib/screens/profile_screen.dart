import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_info.dart';

/// Membuka halaman Profil / Tentang Aplikasi.
void openProfileScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ProfileScreen()),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _features = [
    'Ringkasan total pengeluaran dan tagihan penghuni',
    'Catat, ubah, dan hapus pengeluaran',
    'Pembagian biaya rata ke semua penghuni',
    'Pembayaran sebagian dan sisa tagihan',
    'Riwayat pembayaran',
    'Kelola penghuni dan kamar',
    'Info cuaca dari REST API',
  ];

  static const _tech = [
    'Flutter',
    'Dart',
    'Provider',
    'Supabase',
    'REST API (Open-Meteo)',
  ];

  @override
  Widget build(BuildContext context) {
    final name = AppInfo.studentName.trim();
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        title: const Text('Profil',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFFE3F7EE), Colors.white],
                      stops: [0.0, 0.6],
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary,
                        child: Text(initial,
                            style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 14),
                      Text(AppInfo.studentName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('NIM ${AppInfo.nim}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Data Mahasiswa',
                  child: Column(
                    children: const [
                      _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Nama',
                          value: AppInfo.studentName),
                      _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'NIM',
                          value: AppInfo.nim),
                      _InfoRow(
                          icon: Icons.school_outlined,
                          label: 'Kelas',
                          value: AppInfo.kelas),
                      _InfoRow(
                          icon: Icons.menu_book_outlined,
                          label: 'Mata Kuliah',
                          value: AppInfo.course,
                          isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Tentang Aplikasi',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppInfo.description,
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textGrey)),
                      const SizedBox(height: 12),
                      const _InfoRow(
                          icon: Icons.apps_outlined,
                          label: 'Aplikasi',
                          value: AppInfo.appName),
                      const _InfoRow(
                          icon: Icons.tag,
                          label: 'Versi',
                          value: AppInfo.version,
                          isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Fitur Utama',
                  child: Column(
                    children: [
                      for (final f in _features)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(f,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.35,
                                        color: AppColors.textDark)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Teknologi',
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in _tech)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.greyBox,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark)),
                          ),
                      ],
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13.5, color: AppColors.textGrey)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}