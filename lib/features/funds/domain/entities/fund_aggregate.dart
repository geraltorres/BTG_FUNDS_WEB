import 'fund.dart';
import 'transaction.dart';

class FundAggregate {
  final List<Fund> funds;
  final List<Transaction> transactions;
  final int balance;

  const FundAggregate({
    required this.funds,
    required this.transactions,
    required this.balance,
  });

  FundAggregate copyWith({
    List<Fund>? funds,
    List<Transaction>? transactions,
    int? balance,
  }) {
    return FundAggregate(
      funds: funds ?? this.funds,
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
    );
  }
}
