import 'package:flutter_test/flutter_test.dart';
import 'package:kontrakanku/main.dart';

void main() {
  testWidgets('Dashboard tampil saat aplikasi dibuka', (tester) async {
    await tester.pumpWidget(const KontrakankuApp());

    expect(find.text('TOTAL BEBAN BULAN INI'), findsOneWidget);
    expect(find.text('Iuran Penghuni Kontrakan'), findsOneWidget);
  });
}