// models/journal_voucher_model.dart

class JournalVoucher {
  final String id;
  final String date;
  final String description;
  final int entries;
  final String addedBy;
  final String amount;

  JournalVoucher({
    required this.id,
    required this.date,
    required this.description,
    required this.entries,
    required this.addedBy,
    required this.amount,
  });

  factory JournalVoucher.fromJson(Map<String, dynamic> json) {
    return JournalVoucher(
      id: json['voucher_no'] ?? '',
      date: json['voucher_data'] ?? '',
      description: json['num_entries'] ?? '',
      entries: json['entries'] ?? 0,
      addedBy: json['created_by'] ?? '',
      amount: json['amount']?.toString() ?? '0',
    );
  }
}