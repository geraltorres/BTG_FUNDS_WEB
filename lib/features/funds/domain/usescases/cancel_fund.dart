import 'package:btg_funds_web/features/funds/domain/repositories/fund_repository.dart';

class CancelFund {
  final FundRepository repository;

  CancelFund(this.repository);

  Future<void> call(int fundId, String notification) {
    return repository.cancelFund(fundId, notification);
  }
}
