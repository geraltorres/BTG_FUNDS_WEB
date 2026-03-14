import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_state.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/home_page.dart';
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

  testWidgets("shows loading indicator when loading", (tester) async {
    when(() => bloc.state).thenReturn(const FundState(loading: true));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<FundBloc>.value(
          value: bloc,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("navigates to subscribe page", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.text("Suscribirse"));

    await tester.pumpAndSettle();

    expect(find.text("Suscribirse a fondo"), findsOneWidget);
  });
}
