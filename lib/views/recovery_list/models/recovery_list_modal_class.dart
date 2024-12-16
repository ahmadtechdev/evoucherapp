class RecoveryListModel {
  String rlName;
  String dateCreated;
  double totalAmount;
  double received;
  double remaining;

  RecoveryListModel({
    required this.rlName,
    required this.dateCreated,
    required this.totalAmount,
    required this.received,
    required this.remaining,
  });
}