String formatRupiah(int value) {
  final s = value.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp${value < 0 ? '-' : ''}$buf';
}

const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

String formatTanggal(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')} ${_bulan[d.month - 1]} ${d.year}';