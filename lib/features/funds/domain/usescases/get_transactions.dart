import '../entities/transaction.dart';
import '../repositories/fund_repository.dart';

class GetTransactions {
  final FundRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() {
    return repository.getTransactions();
  }
}
