const _bulanPanjang = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

const _bulanSingkat = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

/// 25 Oktober 2024
String formatTanggalPanjang(DateTime d) =>
    '${d.day} ${_bulanPanjang[d.month - 1]} ${d.year}';

/// Okt (untuk bulan 10)
String namaBulanSingkat(int month) => _bulanSingkat[month - 1];

/// "Okt" dan "2024" di dua baris.
String formatBulanTahunDuaBaris(DateTime d) =>
    '${_bulanSingkat[d.month - 1]}\n${d.year}';