import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../models/tenant.dart';
import '../repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _repository;

  PaymentProvider(this._repository);

  List<Tenant> _tenants = [];
  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _error;

  List<Tenant> get tenants => List.unmodifiable(_tenants);
  List<Payment> get payments => List.unmodifiable(_payments);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Jumlah penghuni (minimal 1 supaya aman dipakai sebagai pembagi).
  int get peopleCount => _tenants.isEmpty ? 1 : _tenants.length;

  int get totalCollected => _payments.fold<int>(0, (sum, p) => sum + p.amount);

  int paidBy(int tenantId) => _payments
      .where((p) => p.tenantId == tenantId)
      .fold<int>(0, (sum, p) => sum + p.amount);

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.getTenants(),
        _repository.getPayments(),
      ]);
      _tenants = results[0] as List<Tenant>;
      _payments = results[1] as List<Payment>;
    } catch (e) {
      debugPrint('loadAll error: $e');
      _error = 'Gagal memuat data pembayaran';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Tenant? tenantById(int id) {
    for (final t in _tenants) {
      if (t.id == id) return t;
    }
    return null;
  }

  /// Total yang sudah dibayar penghuni sampai (dan termasuk) pembayaran [p].
  int paidUpTo(Payment p) {
    return _payments.where((x) {
      if (x.tenantId != p.tenantId) return false;
      final cmp = x.paidAt.compareTo(p.paidAt);
      return cmp < 0 || (cmp == 0 && (x.id ?? 0) <= (p.id ?? 0));
    }).fold<int>(0, (sum, x) => sum + x.amount);
  }

  /// Menambah pembayaran baru. Mengembalikan true jika berhasil.
  Future<bool> addPayment(Payment payment) async {
    try {
      final saved = await _repository.addPayment(payment);
      _payments = [saved, ..._payments]..sort((a, b) {
          final c = b.paidAt.compareTo(a.paidAt);
          return c != 0 ? c : (b.id ?? 0).compareTo(a.id ?? 0);
        });
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('addPayment error: $e');
      return false;
    }
  }
}