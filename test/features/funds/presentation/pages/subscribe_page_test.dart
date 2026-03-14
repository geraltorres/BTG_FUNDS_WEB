import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/subscribe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fund = Fund(
    id: 1,
    name: "FPV Test",
    minAmount: 100000,
    category: 'FPV',
  );

  testWidgets("shows validation error if amount is empty", (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SubscribePage(fund: fund, balance: 500000)),
    );

    await tester.tap(find.text("Confirmar suscripción"));

    await tester.pump();

    expect(find.text("Ingrese un monto"), findsOneWidget);
  });
}
