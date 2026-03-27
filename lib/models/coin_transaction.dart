class CoinTransaction {
  const CoinTransaction({
    required this.id,
    required this.source,
    required this.amount,
    required this.isCredit,
    required this.timestamp,
  });

  final String id;
  final String source;
  final int amount;
  final bool isCredit;
  final DateTime timestamp;
}
