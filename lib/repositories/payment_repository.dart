import '../models/payment.dart';
import '../models/tenant.dart';
import '../services/payment_service.dart';

class PaymentRepository {
  final PaymentService _service;

  PaymentRepository(this._service);

  Future<List<Tenant>> getTenants() => _service.fetchTenants();

  Future<List<Payment>> getPayments() => _service.fetchPayments();

  Future<Payment> addPayment(Payment payment) =>
      _service.insertPayment(payment);

  Future<Tenant> addTenant({
    required String name,
    required String fullName,
    required int room,
  }) =>
      _service.insertTenant(name: name, fullName: fullName, room: room);

  Future<Tenant> updateTenant(Tenant tenant) => _service.updateTenant(tenant);

  Future<void> deleteTenant(int id) => _service.deleteTenant(id);
}