import 'package:btg_funds_web/core/errors/failures.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:btg_funds_web/features/funds/domain/repositories/fund_repository.dart';
import 'package:dartz/dartz.dart';

class GetFunds {
  final FundRepository repository;

  GetFunds(this.repository);

  Future<Either<Failure, FundAggregate>> call() {
    return repository.getFunds();
  }
}
