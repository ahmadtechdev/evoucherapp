class DailyCashActivityModel {
  final String vNumber;
  final String account;
  final String description;
  final String status;
  final String amount;

  DailyCashActivityModel({
    required this.vNumber,
    required this.account,
    required this.description,
    required this.status,
    required this.amount,
  });

  factory DailyCashActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyCashActivityModel(
      vNumber: json['v_number'] ?? '',
      account: json['account'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? '0',
    );
  }
}