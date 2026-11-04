import '../data/dummy_data.dart';
import '../models/payment.dart';
import '../models/tenant.dart';

/// Sumber data penghuni dan pembayaran (sementara data dummy).
class PaymentService {
  Future<List<Tenant>> fetchTenants() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.of(dummyTenants);
  }

  Future<List<Payment>> fetchPayments() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.of(dummyPayments);
  }
}