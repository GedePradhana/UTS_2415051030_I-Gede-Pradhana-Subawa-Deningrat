import 'package:flutter_test/flutter_test.dart';
import 'package:kontrakanku/main.dart';

void main() {
  testWidgets('Dashboard tampil setelah data dimuat', (tester) async {
    await tester.pumpWidget(const KontrakankuApp());
    await tester.pumpAndSettle(); // tunggu loading data selesai

    expect(find.text('TOTAL BEBAN BULAN INI'), findsOneWidget);
    expect(find.text('Iuran Penghuni Kontrakan'), findsOneWidget);
  });
}