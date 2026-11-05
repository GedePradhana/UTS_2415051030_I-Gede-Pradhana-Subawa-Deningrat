import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseRepository {
  final ExpenseService _service;

  ExpenseRepository(this._service);

  /// Pengeluaran diurutkan dari tanggal terbaru.
  Future<List<Expense>> getExpenses() async {
    final data = await _service.fetchExpenses();
    data.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return data;
  }

  Future<Expense> addExpense(Expense expense) =>
      _service.insertExpense(expense);
}