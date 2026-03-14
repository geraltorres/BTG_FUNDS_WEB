import 'package:bloc_test/bloc_test.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/domain/usescases/get_funds.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_event.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFunds extends Mock implements GetFunds {}

void main() {
  late FundBloc bloc;
  late MockGetFunds mockGetFunds;

  setUp(() {
    mockGetFunds = MockGetFunds();

    bloc = FundBloc(mockGetFunds);
  });

  final initialTransaction = Transaction(
    fundId: 1,
    fundName: "FPV TEST",
    amount: 100000,
    type: "SUBSCRIPTION",
    date: DateTime.now(),
    notification: "SMS",
  );

  final initialAggregate = FundAggregate(
    funds: const [],
    balance: 400000,
    transactions: [initialTransaction],
  );
  // Cancel Subscription Test
  blocTest<FundBloc, FundState>(
    "cancel subscription restores balance and adds cancel transaction",

    build: () => bloc,

    seed: () => FundState(portfolio: initialAggregate),

    act: (bloc) => bloc.add(CancelFundEvent(1, 'SMS')),

    expect: () => [
      isA<FundState>()
          .having((s) => s.portfolio.balance, "balance", 500000)
          .having(
            (s) => s.portfolio.transactions.length,
            "transactions length",
            2,
          )
          .having(
            (s) => s.portfolio.transactions.last.type,
            "last transaction type",
            "CANCEL",
          ),
    ],
  );
  // Cancel Subscription Test Without Subscription
  blocTest<FundBloc, FundState>(
    "subscribe reduces balance and registers transaction",
    build: () => bloc,
    seed: () => FundState(
      portfolio: FundAggregate(
        funds: const [],
        transactions: const [],
        balance: 500000,
      ),
    ),
    act: (bloc) => bloc.add(
      SubscribeFundEvent(
        fundId: 1,
        fundName: "FPV TEST",
        amount: 100000,
        notification: "EMAIL",
      ),
    ),
    expect: () => [
      isA<FundState>()
          .having((s) => s.portfolio.balance, "balance", 400000)
          .having((s) => s.portfolio.transactions.length, "tx", 1),
    ],
  );
}
