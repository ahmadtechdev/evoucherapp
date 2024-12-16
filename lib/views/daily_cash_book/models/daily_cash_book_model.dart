class DailyCashBookModel {
  final String id;
  final DateTime date;
  final String description;
  final double receipt;
  final double payment;
  final double balance;

  DailyCashBookModel({
    required this.id,
    required this.date,
    required this.description,
    required this.receipt,
    required this.payment,
    required this.balance,
  });
}