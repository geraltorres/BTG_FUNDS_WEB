abstract class FundEvent {}

class LoadFunds extends FundEvent {}

class SubscribeFundEvent extends FundEvent {
  final int fundId;
  final String fundName;
  final int amount;
  final String notification;

  SubscribeFundEvent({
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.notification,
  });
}

class CancelFundEvent extends FundEvent {
  final int fundId;
  final String notification;

  CancelFundEvent(this.fundId, this.notification);
}
