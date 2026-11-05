import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Dekorasi input yang dipakai di form pengeluaran.
InputDecoration formInputDecoration({
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

/// Label di atas kolom form.
class FormLabel extends StatelessWidget {
  final String text;

  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151))),
    );
  }
}