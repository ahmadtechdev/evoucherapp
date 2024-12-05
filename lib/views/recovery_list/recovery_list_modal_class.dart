
class RecoveryListItem {
  final String rlName;
  final String dateCreated;
  final double totalAmount;
  final double received;
  final double remaining;
  final String remarks;

  RecoveryListItem({
    required this.rlName,
    required this.dateCreated,
    required this.totalAmount,
    required this.received,
    required this.remaining,
    this.remarks="",
  });
}