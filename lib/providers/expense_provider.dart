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

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<Expense> get filteredExpenses {
    if (_selectedCategory == 'Semua') return expenses;
    return _expenses
        .where((e) => e.category.label == _selectedCategory)
        .toList();
  }

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
}