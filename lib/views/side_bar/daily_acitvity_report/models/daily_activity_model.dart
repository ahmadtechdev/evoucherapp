class DailyActivityReportModel {
  final String voucherNumber;
  final String date;
  final String description;
  final String accountName;
  final String addedBy;
  final double debit;
  final double credit;
  final double runningBalance;

  DailyActivityReportModel({
    required this.voucherNumber,
    required this.date,
    required this.description,
    required this.accountName,
    required this.addedBy,
    required this.debit,
    required this.credit,
    required this.runningBalance,
  });

  factory DailyActivityReportModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityReportModel(
      voucherNumber: json['voucher_number'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      accountName: json['account_name'] ?? '',
      addedBy: json['added_by'] ?? '',
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      runningBalance: (json['running_balance'] ?? 0).toDouble(),
    );
  }
}
