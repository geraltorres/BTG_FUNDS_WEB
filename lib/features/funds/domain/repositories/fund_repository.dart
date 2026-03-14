import 'package:btg_funds_web/core/errors/failures.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:dartz/dartz.dart';

abstract class FundRepository {
  Future<Either<Failure, FundAggregate>> getFunds();

  Future<List<Transaction>> getTransactions();

  Future<void> subscribeFund(
    int fundId,
    String fundName,
    int amount,
    String notification,
  );

  Future<void> cancelFund(int fundId, String notification);
}
