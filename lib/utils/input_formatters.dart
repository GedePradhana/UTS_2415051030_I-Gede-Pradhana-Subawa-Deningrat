import 'package:flutter/services.dart';

/// Memformat angka saat diketik: 150000 -> 150.000
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    digits = digits.replaceFirst(RegExp(r'^0+'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    if (digits.length > 10) digits = digits.substring(0, 10);

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write('.');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// "150.000" -> 150000 (null jika kosong/tidak valid)
int? parseRupiah(String text) => int.tryParse(text.replaceAll('.', ''));