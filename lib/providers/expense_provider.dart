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

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _expenses = await _repository.getExpenses();
    } catch (e) {
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
}