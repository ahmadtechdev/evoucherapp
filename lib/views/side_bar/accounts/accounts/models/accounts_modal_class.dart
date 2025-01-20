class AccountModel {
  final String id;
  final String name;
  final String subHead;
  final String addedBy; // Add this if you want to keep the existing structure

  AccountModel({
    required this.id,
    required this.name,
    required this.subHead,
    this.addedBy = '', // Optional, with a default empty string
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['account_id'] ?? '',
      name: json['account_name'] ?? '',
      subHead: json['subhead_name'] ?? '',
      // You might want to add logic to populate addedBy if needed
    );
  }
}