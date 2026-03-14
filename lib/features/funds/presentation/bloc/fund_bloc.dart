import 'package:btg_funds_web/features/funds/domain/usescases/get_funds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/base_bloc.dart';
import '../../domain/entities/transaction.dart';

import 'fund_event.dart';
import 'fund_state.dart';

class FundBloc extends BaseBloc<FundEvent, FundState> {
  final GetFunds getFunds;

  FundBloc(this.getFunds) : super(const FundState()) {
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeFundEvent>(_onSubscribe);
    on<CancelFundEvent>(_onCancel);
  }

  /// Load Funds
  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundState> emit) async {
    await executeUseCase(
      () => getFunds(),

      emit,

      () => state.copyWith(loading: true, error: null, successMessage: null),

      (message) => state.copyWith(loading: false, error: message),

      (aggregate) => state.copyWith(loading: false, portfolio: aggregate),
    );
  }

  /// subscribse to fund
  Future<void> _onSubscribe(
    SubscribeFundEvent event,
    Emitter<FundState> emit,
  ) async {
    final portfolio = state.portfolio;

    final fund = portfolio.funds.firstWhere((f) => f.id == event.fundId);

    final alreadySubscribed = portfolio.transactions.any(
      (t) => t.fundId == event.fundId && t.type == "SUBSCRIPTION",
    );

    if (alreadySubscribed) {
      emit(
        state.copyWith(
          error: "Ya existe una suscripción activa para este fondo",
        ),
      );
      return;
    }

    /// minimium ammount validation
    if (event.amount < fund.minAmount) {
      emit(state.copyWith(error: "El monto es menor al mínimo permitido"));

      return;
    }

    /// ammount validation
    if (event.amount > portfolio.balance) {
      emit(state.copyWith(error: "Saldo insuficiente"));

      return;
    }

    /// Register transaction
    final newTransaction = Transaction(
      fundId: event.fundId,
      fundName: event.fundName,
      amount: event.amount,
      type: "SUBSCRIPTION",
      date: DateTime.now(),
      notification: event.notification,
    );

    final updatedPortfolio = portfolio.copyWith(
      balance: portfolio.balance - event.amount,
      transactions: [...portfolio.transactions, newTransaction],
    );

    emit(
      state.copyWith(
        portfolio: updatedPortfolio,
        successMessage: 'Suscripción Exitosa',
      ),
    );
  }

  /// cancelar participación
  Future<void> _onCancel(CancelFundEvent event, Emitter<FundState> emit) async {
    final portfolio = state.portfolio;

    final subscription = portfolio.transactions
        .where((t) => t.fundId == event.fundId && t.type == "SUBSCRIPTION")
        .toList();

    if (subscription.isEmpty) {
      emit(state.copyWith(error: "No existe una suscripción activa"));

      return;
    }

    final tx = subscription.last;

    final alreadyCancel = portfolio.transactions.any(
      (t) => t.fundId == event.fundId && t.type == "CANCEL",
    );

    if (alreadyCancel) {
      emit(
        state.copyWith(
          error: "Ya existe una suscripción cancelada para este fondo",
        ),
      );
      return;
    }

    final cancelTx = Transaction(
      fundId: tx.fundId,
      fundName: tx.fundName,
      amount: tx.amount,
      type: "CANCEL",
      date: DateTime.now(),
      notification: tx.notification,
    );

    final updatedPortfolio = portfolio.copyWith(
      balance: portfolio.balance + tx.amount,
      transactions: [...portfolio.transactions, cancelTx],
    );

    emit(
      state.copyWith(
        portfolio: updatedPortfolio,
        successMessage: 'Cancelación Exitosa',
      ),
    );
  }
}
