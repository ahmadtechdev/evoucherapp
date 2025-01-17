
// daily_cash_book_model.dart
import 'package:intl/intl.dart';

class DailyCashBookModel {
  final String voucherId;
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final String balance;

  DailyCashBookModel({
    required this.voucherId,
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory DailyCashBookModel.fromJson(Map<String, dynamic> json) {
    return DailyCashBookModel(
      voucherId: json['voucher_id'],
      date: DateFormat('E, d MMM y').parse(json['date']),
      description: json['description'],
      debit: double.parse(json['debit'].replaceAll(',', '')),
      credit: double.parse(json['credit'].replaceAll(',', '')),
      balance: json['balance'],
    );
  }
}