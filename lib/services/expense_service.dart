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
}