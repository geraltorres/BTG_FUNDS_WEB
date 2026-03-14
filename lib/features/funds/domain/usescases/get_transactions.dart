import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/domain/repositories/fund_repository.dart';

class GetTransactions {
  final FundRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() {
    return repository.getTransactions();
  }
}
