import '../repositories/fund_repository.dart';

class SubscribeFund {
  final FundRepository repository;

  SubscribeFund(this.repository);

  Future<void> call(
    int fundId,
    String fundName,
    int amount,
    String notification,
  ) {
    return repository.subscribeFund(fundId, fundName, amount, notification);
  }
}
