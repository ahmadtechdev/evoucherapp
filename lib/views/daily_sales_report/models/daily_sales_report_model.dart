// lib/models/sale_entry.dart
class SaleEntry {
  final String date;
  final Map<String, dynamic> summary;
  final Map<String, dynamic> details;

  SaleEntry({required this.date, required this.summary, required this.details});

  factory SaleEntry.fromMap(Map<String, dynamic> map) {
    return SaleEntry(
      date: map['date'],
      summary: map['summary'],
      details: map['details'],
    );
  }
}