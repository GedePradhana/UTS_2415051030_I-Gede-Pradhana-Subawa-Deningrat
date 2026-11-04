import '../data/dummy_data.dart';
import '../models/expense.dart';

/// Sumber data pengeluaran.
/// Saat ini memakai data dummy; diganti Supabase pada tahap database.
class ExpenseService {
  Future<List<Expense>> fetchExpenses() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulasi jaringan
    return List.of(dummyExpenses);
    
  }
}