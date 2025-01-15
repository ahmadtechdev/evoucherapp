// recovery_list_modal_class.dart
class RecoveryListModel {
  String id;
  String rlName;
  String dateCreated;
  double totalAmount;
  double received;
  double remaining;
  Map<String, String> formatted;

  RecoveryListModel({
    required this.id,
    required this.rlName,
    required this.dateCreated,
    required this.totalAmount,
    required this.received,
    required this.remaining,
    required this.formatted,
  });

  factory RecoveryListModel.fromJson(Map<String, dynamic> json) {
    return RecoveryListModel(
      id: json['id'] ?? '',
      rlName: json['name'] ?? '',
      dateCreated: json['date_created'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      received: (json['received_amount'] ?? 0).toDouble(),
      remaining: (json['remaining_amount'] ?? 0).toDouble(),
      formatted: Map<String, String>.from(json['formatted'] ?? {}),
    );
  }
}