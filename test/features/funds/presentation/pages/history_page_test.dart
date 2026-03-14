import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_state.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/history_page.dart';
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

  testWidgets("shows empty message when no transactions", (tester) async {
    when(() => bloc.state).thenReturn(const FundState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FundBloc>.value(
          value: bloc,
          child: const HistoryPage(),
        ),
      ),
    );

    expect(find.text("No hay transacciones registradas"), findsOneWidget);
  });
}
