class Transaction {
  final int fundId;
  final String fundName;
  final int amount;
  final String type;
  final DateTime date;
  final String notification;

  const Transaction({
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.type,
    required this.date,
    required this.notification,
  });
}
