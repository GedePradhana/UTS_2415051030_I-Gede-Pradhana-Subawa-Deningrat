import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment.dart';
import '../models/tenant.dart';

/// Mengakses tabel "tenants" dan "payments" di Supabase.
class PaymentService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Tenant>> fetchTenants() async {
    final rows = await _client.from('tenants').select().order('room');
    return rows.map<Tenant>((row) => Tenant.fromJson(row)).toList();
  }

  Future<List<Payment>> fetchPayments() async {
    final rows = await _client
        .from('payments')
        .select()
        .order('paid_at', ascending: false);
    return rows.map<Payment>((row) => Payment.fromJson(row)).toList();
  }

  /// Menyimpan pembayaran baru dan mengembalikan data yang tersimpan.
  Future<Payment> insertPayment(Payment payment) async {
    final row = await _client
        .from('payments')
        .insert(payment.toJson())
        .select()
        .single();
    return Payment.fromJson(row);
  }

  Future<Tenant> insertTenant({
    required String name,
    required String fullName,
    required int room,
  }) async {
    final row = await _client
        .from('tenants')
        .insert({'name': name, 'full_name': fullName, 'room': room})
        .select()
        .single();
    return Tenant.fromJson(row);
  }

  Future<Tenant> updateTenant(Tenant tenant) async {
    final row = await _client
        .from('tenants')
        .update({
          'name': tenant.name,
          'full_name': tenant.fullName,
          'room': tenant.room,
        })
        .eq('id', tenant.id)
        .select()
        .single();
    return Tenant.fromJson(row);
  }

  /// Menghapus penghuni (pembayarannya ikut terhapus oleh database).
  Future<void> deleteTenant(int id) async {
    final deleted =
        await _client.from('tenants').delete().eq('id', id).select();
    if (deleted.isEmpty) {
      throw Exception('Penghuni tidak terhapus (id $id tidak ditemukan)');
    }
  }
}