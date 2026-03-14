import 'package:btg_funds_web/core/errors/failures.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund_aggregate.dart';
import 'package:dartz/dartz.dart';

import '../repositories/fund_repository.dart';

class GetFunds {
  final FundRepository repository;

  GetFunds(this.repository);

  Future<Either<Failure, FundAggregate>> call() {
    return repository.getFunds();
  }
}
