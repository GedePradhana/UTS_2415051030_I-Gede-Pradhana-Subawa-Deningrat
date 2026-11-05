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
}