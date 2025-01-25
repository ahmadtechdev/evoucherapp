class AccountModel {
  final String id;
  final String name;
  final String subHead;
  final String addedBy; // Add this if you want to keep the existing structure
  final String debit; // Add this if you want to keep the existing structure
  final String credit; // Add this if you want to keep the existing structure

  AccountModel({
    required this.id,
    required this.name,
    required this.subHead,
    required this.debit,
    required this.credit,
    this.addedBy = '', // Optional, with a default empty string
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['account_id'] ?? '',
      name: json['account_name'] ?? '',
      subHead: json['subhead_name'] ?? '',
      debit: json['account_debit'] ?? '',
      credit: json['account_credit'] ?? '',
      // You might want to add logic to populate addedBy if needed
    );
  }
}