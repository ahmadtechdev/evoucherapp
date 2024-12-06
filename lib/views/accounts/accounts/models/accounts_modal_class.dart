class AccountModel {
  final String id;
  final String name;
  final String subHead;
 // Using dummy data for now
  final String addedBy; // Using dummy data for now

  AccountModel({
    required this.id,
    required this.name,
    required this.subHead,
    required this.addedBy,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['account_id'] ?? '',
      name: json['account_name'] ?? '',
      subHead: json['subhead_name'] ?? '', // Dummy contact
      addedBy: 'Admin User', // Dummy addedBy
    );
  }
}