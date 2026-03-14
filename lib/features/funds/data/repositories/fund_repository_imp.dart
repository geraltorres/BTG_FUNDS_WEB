import 'package:btg_funds_web/core/errors/exceptions.dart';
import 'package:btg_funds_web/core/errors/failures.dart';
import 'package:btg_funds_web/core/network/network_info.dart';
import 'package:btg_funds_web/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/domain/repositories/fund_repository.dart';
import 'package:dartz/dartz.dart';

class FundRepositoryImpl implements FundRepository {
  final FundsRemoteDatasource datasource;
  final NetworkInfo networkInfo;

  int balance = 500000;

  final List<Transaction> transactions = [];

  FundRepositoryImpl(this.datasource, this.networkInfo);

  @override
  Future<Either<Failure, FundAggregate>> getFunds() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await datasource.getFunds();
        final aggregate = FundAggregate(
          funds: result,
          transactions: transactions,
          balance: balance,
        );
        return Right(aggregate);
      } on CacheException {
        return Left(CacheFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> subscribeFund(
    int fundId,
    String fundName,
    int amount,
    String notification,
  ) async {
    if (amount > balance) {
      throw Exception("Saldo insuficiente");
    }

    balance -= amount;

    transactions.add(
      Transaction(
        fundId: fundId,
        fundName: fundName,
        amount: amount,
        type: "SUBSCRIPTION",
        date: DateTime.now(),
        notification: notification,
      ),
    );
  }

  @override
  Future<void> cancelFund(int fundId, String notification) async {
    final tx = transactions.lastWhere(
      (t) => t.fundId == fundId && t.type == "SUBSCRIPTION",
    );

    balance += tx.amount;

    transactions.add(
      Transaction(
        fundId: tx.fundId,
        fundName: tx.fundName,
        amount: tx.amount,
        type: "CANCEL",
        date: DateTime.now(),
        notification: notification,
      ),
    );
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    return transactions;
  }
}
