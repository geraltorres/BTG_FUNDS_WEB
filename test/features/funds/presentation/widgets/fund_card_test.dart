import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_web/features/funds/presentation/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fund = Fund(
    id: 1,
    name: "FPV Conservador",
    minAmount: 75000,
    category: 'FPV',
  );

  testWidgets("renders fund information correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FundCard(fund: fund, onSubscribe: () {}),
        ),
      ),
    );

    expect(find.text("FPV Conservador"), findsOneWidget);
    expect(find.textContaining("75000"), findsOneWidget);
    expect(find.text("Suscribirse"), findsOneWidget);
  });

  testWidgets("calls onSubscribe when button is tapped", (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FundCard(
            fund: fund,
            onSubscribe: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text("Suscribirse"));

    await tester.pump();

    expect(pressed, true);
  });
}
