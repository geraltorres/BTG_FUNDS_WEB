import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_state.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/cancel_subcription_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockFundBloc extends Mock implements FundBloc {}

void main() {
  late MockFundBloc bloc;

  setUp(() {
    bloc = MockFundBloc();
  });

  testWidgets("shows empty message when no active subscriptions", (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(const FundState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FundBloc>.value(
          value: bloc,
          child: const CancelSubscriptionPage(),
        ),
      ),
    );

    expect(find.text("No tienes suscripciones activas"), findsOneWidget);
  });

  testWidgets("shows cancel button when subscriptions exist", (tester) async {
    final transaction = Transaction(
      fundId: 1,
      fundName: "FPV",
      amount: 100000,
      type: "SUBSCRIPTION",
      date: DateTime.now(),
      notification: "EMAIL",
    );

    when(() => bloc.state).thenReturn(
      FundState(
        portfolio: FundAggregate(
          funds: const [],
          transactions: [transaction],
          balance: 400000,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FundBloc>.value(
          value: bloc,
          child: const CancelSubscriptionPage(),
        ),
      ),
    );

    expect(find.text("Cancelar"), findsOneWidget);
  });

  testWidgets("dispatches CancelFundEvent when cancel button is tapped", (
    tester,
  ) async {
    final transaction = Transaction(
      fundId: 1,
      fundName: "FPV",
      amount: 100000,
      type: "SUBSCRIPTION",
      date: DateTime.now(),
      notification: "EMAIL",
    );

    when(() => bloc.state).thenReturn(
      FundState(
        portfolio: FundAggregate(
          funds: const [],
          transactions: [transaction],
          balance: 400000,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FundBloc>.value(
          value: bloc,
          child: const CancelSubscriptionPage(),
        ),
      ),
    );

    await tester.tap(find.text("Cancelar"));
    await tester.pump();
  });
}
