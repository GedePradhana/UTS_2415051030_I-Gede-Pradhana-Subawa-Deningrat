enum PaymentMethod {
  tunai('Tunai (Cash)'),
  transfer('Transfer Bank');

  final String label;
  const PaymentMethod(this.label);

  static PaymentMethod fromName(String? name) {
    return PaymentMethod.values.firstWhere(
      (m) => m.name == name,
      orElse: () => PaymentMethod.tunai,
    );
  }
}

class Payment {
  final int? id;
  final int tenantId;
  final int amount;
  final PaymentMethod method;
  final DateTime paidAt;
  final String? note;

  const Payment({
    this.id,
    required this.tenantId,
    required this.amount,
    required this.method,
    required this.paidAt,
    this.note,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int?,
      tenantId: json['tenant_id'] as int,
      amount: (json['amount'] as num).toInt(),
      method: PaymentMethod.fromName(json['method'] as String?),
      paidAt: DateTime.parse(json['paid_at'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tenant_id': tenantId,
      'amount': amount,
      'method': method.name,
      'paid_at': paidAt.toIso8601String().split('T').first,
      'note': note,
    };
  }
}