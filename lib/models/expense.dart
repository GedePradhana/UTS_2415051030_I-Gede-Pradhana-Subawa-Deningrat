enum ExpenseCategory {
  listrik('Listrik'),
  air('Air'),
  gas('Gas'),
  lainnya('Lainnya');

  final String label;
  const ExpenseCategory(this.label);

  static ExpenseCategory fromName(String? name) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ExpenseCategory.lainnya,
    );
  }
}

class Expense {
  final int? id; // null = belum disimpan ke database
  final String title;
  final ExpenseCategory category;
  final int amount;
  final DateTime expenseDate;
  final String? note;

  const Expense({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.expenseDate,
    this.note,
  });

  /// Beban per penghuni (dibagi rata).
  int perPerson(int people) => amount ~/ people;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int?,
      title: json['title'] as String,
      category: ExpenseCategory.fromName(json['category'] as String?),
      amount: (json['amount'] as num).toInt(),
      expenseDate: DateTime.parse(json['expense_date'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String().split('T').first,
      'note': note,
    };
  }

  Expense copyWith({
    int? id,
    String? title,
    ExpenseCategory? category,
    int? amount,
    DateTime? expenseDate,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
      note: note ?? this.note,
    );
  }
}