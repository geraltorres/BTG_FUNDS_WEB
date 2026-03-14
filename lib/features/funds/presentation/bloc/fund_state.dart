import 'package:btg_funds_web/core/bloc/base_state.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';

class FundState extends BaseState {
  final FundAggregate portfolio;

  const FundState({
    super.loading,
    super.error,
    super.successMessage,
    this.portfolio = const FundAggregate(
      funds: [],
      transactions: [],
      balance: 500000,
    ),
  });

  @override
  FundState copyWith({
    bool? loading,
    String? error,
    String? successMessage,
    FundAggregate? portfolio,
  }) {
    return FundState(
      loading: loading ?? this.loading,
      error: error,
      successMessage: successMessage,
      portfolio: portfolio ?? this.portfolio,
    );
  }
}
