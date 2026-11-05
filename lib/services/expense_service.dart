import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';

/// Mengakses tabel "expenses" di Supabase.
class ExpenseService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Expense>> fetchExpenses() async {
    final rows = await _client
        .from('expenses')
        .select()
        .order('expense_date', ascending: false);
    return rows.map<Expense>((row) => Expense.fromJson(row)).toList();
  }

  /// Menyimpan pengeluaran baru dan mengembalikan data yang tersimpan (beserta id).
  Future<Expense> insertExpense(Expense expense) async {
    final row = await _client
        .from('expenses')
        .insert(expense.toJson())
        .select()
        .single();
    return Expense.fromJson(row);
  }

  /// Memperbarui pengeluaran berdasarkan id.
  Future<Expense> updateExpense(Expense expense) async {
    // Kolom id tidak boleh ikut diubah.
    final data = expense.toJson()..remove('id');
    final row = await _client
        .from('expenses')
        .update(data)
        .eq('id', expense.id!)
        .select()
        .single();
    return Expense.fromJson(row);
  }
}