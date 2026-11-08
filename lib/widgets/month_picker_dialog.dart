import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';

/// Hasil pemilihan bulan. [month] null berarti "Semua Bulan".
class MonthSelection {
  final DateTime? month;
  const MonthSelection(this.month);
}

/// Dialog pilih bulan. Mengembalikan null jika dibatalkan.
Future<MonthSelection?> showMonthPickerDialog(
  BuildContext context, {
  DateTime? initial,
  required bool Function(DateTime month) hasData,
}) {
  return showDialog<MonthSelection>(
    context: context,
    builder: (_) => _MonthPickerDialog(initial: initial, hasData: hasData),
  );
}

class _MonthPickerDialog extends StatefulWidget {
  final DateTime? initial;
  final bool Function(DateTime month) hasData;

  const _MonthPickerDialog({required this.initial, required this.hasData});

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  static const _minYear = 2020;
  late int _year;
  late final int _maxYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _maxYear = now.year + 1;
    _year = (widget.initial?.year ?? now.year).clamp(_minYear, _maxYear);
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initial;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed:
                        _year > _minYear ? () => setState(() => _year--) : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text('$_year',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark)),
                  ),
                  IconButton(
                    onPressed:
                        _year < _maxYear ? () => setState(() => _year++) : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.8,
                children: [
                  for (var m = 1; m <= 12; m++)
                    _MonthCell(
                      month: m,
                      isSelected: initial != null &&
                          initial.year == _year &&
                          initial.month == m,
                      hasData: widget.hasData(DateTime(_year, m)),
                      onTap: () => Navigator.of(context)
                          .pop(MonthSelection(DateTime(_year, m))),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(const MonthSelection(null)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Semua Bulan',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Batal',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  final int month;
  final bool isSelected;
  final bool hasData;
  final VoidCallback onTap;

  const _MonthCell({
    required this.month,
    required this.isSelected,
    required this.hasData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(namaBulanSingkat(month),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textDark)),
            const SizedBox(height: 3),
            CircleAvatar(
              radius: 2.5,
              backgroundColor: hasData
                  ? (isSelected ? Colors.white : AppColors.primary)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}