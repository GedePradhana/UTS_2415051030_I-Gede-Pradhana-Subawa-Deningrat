// Data sementara. Akan dihapus saat data diambil dari Supabase.
import '../models/expense.dart';
import '../models/payment.dart';
import '../models/tenant.dart';

const dummyTenants = <Tenant>[
  Tenant(id: 1, name: 'Budi', fullName: 'Budi Santoso', room: 1),
  Tenant(id: 2, name: 'Dimas', fullName: 'Dimas Anggara', room: 2),
  Tenant(id: 3, name: 'Rizky', fullName: 'Rizky Ramadhan', room: 3),
];

final dummyExpenses = <Expense>[
  Expense(
      id: 1,
      title: 'Token Listrik Rumah',
      category: ExpenseCategory.listrik,
      amount: 300000,
      expenseDate: DateTime(2024, 10, 25),
      note: 'Token meteran PLN 24 digit untuk lampu, kulkas & colokan.'),
  Expense(
      id: 2,
      title: 'Iuran Wi-Fi Bulanan',
      category: ExpenseCategory.lainnya,
      amount: 375000,
      expenseDate: DateTime(2024, 10, 18),
      note: 'Paket internet Indihome 50 Mbps periode Oktober 2024.'),
  Expense(
      id: 3,
      title: 'Galon Air Aqua (3 Galon)',
      category: ExpenseCategory.air,
      amount: 60000,
      expenseDate: DateTime(2024, 10, 15)),
  Expense(
      id: 4,
      title: 'Tabung Gas Elpiji 3 Kg',
      category: ExpenseCategory.gas,
      amount: 45000,
      expenseDate: DateTime(2024, 10, 10)),
  Expense(
      id: 5,
      title: 'Sewa Kontrakan',
      category: ExpenseCategory.lainnya,
      amount: 2820000,
      expenseDate: DateTime(2024, 10, 1)),
];

final dummyPayments = <Payment>[
  Payment(
      id: 1,
      tenantId: 1,
      amount: 1200000,
      method: PaymentMethod.tunai,
      paidAt: DateTime(2024, 10, 3)),
  Payment(
      id: 2,
      tenantId: 2,
      amount: 600000,
      method: PaymentMethod.transfer,
      paidAt: DateTime(2024, 10, 5)),
  Payment(
      id: 3,
      tenantId: 3,
      amount: 400000,
      method: PaymentMethod.tunai,
      paidAt: DateTime(2024, 10, 12)),
  Payment(
      id: 4,
      tenantId: 2,
      amount: 200000,
      method: PaymentMethod.transfer,
      paidAt: DateTime(2024, 10, 25)),
];