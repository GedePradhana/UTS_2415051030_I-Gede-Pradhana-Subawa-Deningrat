import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository _repository;

  ExpenseProvider(this._repository);

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'Semua'; // shared state: filter kategori
  DateTime? _selectedMonth; // null = semua bulan

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  DateTime? get selectedMonth => _selectedMonth;

  bool _inSelectedMonth(Expense e) =>
      _selectedMonth == null ||
      (e.expenseDate.year == _selectedMonth!.year &&
          e.expenseDate.month == _selectedMonth!.month);

  /// Pengeluaran pada bulan yang dipilih (semua kategori).
  List<Expense> get monthExpenses => _expenses.where(_inSelectedMonth).toList();

  int get monthTotal => monthExpenses.fold<int>(0, (sum, e) => sum + e.amount);

  /// Pengeluaran sesuai filter bulan dan kategori.
  List<Expense> get filteredExpenses {
    final base = monthExpenses;
    if (_selectedCategory == 'Semua') return base;
    return base.where((e) => e.category.label == _selectedCategory).toList();
  }

  /// Apakah ada pengeluaran pada bulan tertentu.
  bool hasExpensesIn(DateTime month) => _expenses.any((e) =>
      e.expenseDate.year == month.year && e.expenseDate.month == month.month);

  List<Expense> get latestExpenses => _expenses.take(3).toList();

  int get totalAmount => _expenses.fold<int>(0, (sum, e) => sum + e.amount);

  /// Mencari pengeluaran terbaru berdasarkan id (null jika tidak ada).
  Expense? findById(int? id) {
    if (id == null) return null;
    for (final e in _expenses) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _expenses = await _repository.getExpenses();
    } catch (e) {
      debugPrint('loadExpenses error: $e');
      _error = 'Gagal memuat data pengeluaran';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    notifyListeners();
  }

  /// Memilih bulan. null = semua bulan.
  void selectMonth(DateTime? month) {
    _selectedMonth = month == null ? null : DateTime(month.year, month.month);
    notifyListeners();
  }

  void _sortByDate() =>
      _expenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));

  /// Menambah pengeluaran baru. Mengembalikan true jika berhasil disimpan.
  Future<bool> addExpense(Expense expense) async {
    try {
      final saved = await _repository.addExpense(expense);
      _expenses = [saved, ..._expenses];
      _sortByDate();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('addExpense error: $e');
      return false;
    }
  }

  /// Memperbarui pengeluaran. Mengembalikan true jika berhasil.
  Future<bool> updateExpense(Expense expense) async {
    try {
      final saved = await _repository.updateExpense(expense);
      _expenses = [
        for (final e in _expenses) e.id == saved.id ? saved : e,
      ];
      _sortByDate();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('updateExpense error: $e');
      return false;
    }
  }

  /// Menghapus pengeluaran. Mengembalikan true jika berhasil.
  Future<bool> deleteExpense(int id) async {
    try {
      await _repository.deleteExpense(id);
      _expenses = _expenses.where((e) => e.id != id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('deleteExpense error: $e');
      return false;
    }
  }

  /// Memuat ulang tanpa menampilkan layar loading. true jika berhasil.
  Future<bool> refresh() async {
    try {
      _expenses = await _repository.getExpenses();
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('refresh expenses error: $e');
      return false;
    }
  }
}