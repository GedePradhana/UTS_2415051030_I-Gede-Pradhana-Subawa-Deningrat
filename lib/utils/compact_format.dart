import 'formatters.dart';

/// Format singkat: 400000 -> Rp400k, 1200000 -> Rp1,2jt.
String formatRupiahCompact(int v) {
  if (v >= 1000000 && v % 100000 == 0) {
    final jt = v / 1000000;
    final text = jt == jt.truncate()
        ? '${jt.toInt()}'
        : jt.toStringAsFixed(1).replaceAll('.', ',');
    return 'Rp${text}jt';
  }
  if (v >= 1000 && v < 1000000 && v % 1000 == 0) return 'Rp${v ~/ 1000}k';
  return formatRupiah(v);
}