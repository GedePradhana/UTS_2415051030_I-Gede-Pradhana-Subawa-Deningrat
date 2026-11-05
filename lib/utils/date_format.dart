const _bulanPanjang = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

/// 25 Oktober 2024
String formatTanggalPanjang(DateTime d) =>
    '${d.day} ${_bulanPanjang[d.month - 1]} ${d.year}';