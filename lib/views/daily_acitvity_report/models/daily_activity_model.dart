class Activity {
  final String voucherNo;
  final DateTime date;
  final String account;
  final String description;
  final double debit;
  final double credit;

  Activity({
    required this.voucherNo,
    required this.date,
    required this.account,
    required this.description,
    required this.debit,
    required this.credit,
  });
}