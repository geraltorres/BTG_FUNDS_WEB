import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/domain/usescases/get_funds.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_event.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetFunds extends Mock implements GetFunds {}

void main() {
  late FundBloc bloc;
  late MockGetFunds mockGetFunds;

  setUp(() {
    mockGetFunds = MockGetFunds();

    bloc = FundBloc(mockGetFunds);
  });

  final aggregate = FundAggregate(funds: [], transactions: [], balance: 500000);

  blocTest<FundBloc, FundState>(
    "emits loading then portfolio when LoadFunds succeeds",

    build: () {
      when(() => mockGetFunds()).thenAnswer((_) async => Right(aggregate));

      return bloc;
    },

    act: (bloc) => bloc.add(LoadFunds()),

    expect: () => [
      const FundState(loading: true),

      FundState(loading: false, portfolio: aggregate),
    ],
  );

  //Subscription Test
  blocTest<FundBloc, FundState>(
    "updates balance when subscribing",

    build: () {
      when(() => mockGetFunds()).thenAnswer((_) async => Right(aggregate));

      return bloc;
    },

    seed: () => FundState(portfolio: aggregate),

    act: (bloc) => bloc.add(
      SubscribeFundEvent(
        fundId: 1,
        fundName: "TEST FUND",
        amount: 100000,
        notification: "EMAIL",
      ),
    ),

    expect: () => [
      isA<FundState>().having((s) => s.portfolio.balance, "balance", 400000),
    ],
  );

  //Cancelation Test
  blocTest<FundBloc, FundState>(
    "restores balance when canceling",

    build: () => bloc,

    seed: () => FundState(
      portfolio: FundAggregate(
        funds: [],
        balance: 400000,
        transactions: [
          Transaction(
            fundId: 1,
            fundName: "TEST",
            amount: 100000,
            type: "SUBSCRIPTION",
            date: DateTime.now(),
            notification: "SMS",
          ),
        ],
      ),
    ),

    act: (bloc) => bloc.add(CancelFundEvent(1, "SMS")),

    expect: () => [
      isA<FundState>().having((s) => s.portfolio.balance, "balance", 500000),
    ],
  );

  blocTest<FundBloc, FundState>(
    "rejects subscription below minimum amount",
    build: () => bloc,
    seed: () => FundState(
      portfolio: FundAggregate(
        funds: [
          const Fund(
            id: 1,
            name: "FONDO ASDQWER",
            minAmount: 100000,
            category: 'FPV',
          ),
        ],
        transactions: const [],
        balance: 500000,
      ),
    ),
    act: (bloc) => bloc.add(
      SubscribeFundEvent(
        fundId: 1,
        fundName: "FPV",
        amount: 50000,
        notification: "EMAIL",
      ),
    ),
    expect: () => [
      isA<FundState>().having(
        (s) => s.error,
        "error",
        "El monto es menor al mínimo permitido",
      ),
    ],
  );
}
