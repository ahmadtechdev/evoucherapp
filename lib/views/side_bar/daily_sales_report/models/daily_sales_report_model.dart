import 'package:intl/intl.dart';

class SaleEntry {
  final String date;
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> details;

  SaleEntry({
    required this.date,
    required this.summary,
    required this.details,
  });

  factory SaleEntry.fromJson(Map<String, dynamic> json) {
    // Parse and format the date
    String formattedDate = '';
    try {
      final DateFormat inputFormat = DateFormat('EEE, dd MMM yyyy');
      final DateTime parsedDate = inputFormat.parse(json['date']);
      formattedDate = inputFormat.format(parsedDate);
    } catch (e) {
      formattedDate = json['date'] ?? '';
    }

    return SaleEntry(
      date: formattedDate,
      summary: {
        'totalP': _parseAmount(json['totals']['total_purchase_amount']),
        'totalS': _parseAmount(json['totals']['total_amount']),
        'pL': _parseAmount(json['totals']['total_profit_loss']),
        'vNo': json['tickets']?[0]?['voucher_number'] ?? '',
      },
      details: (json['tickets'] as List<dynamic>?)
              ?.map((ticket) => {
                    'vDate': _formatDate(ticket['date']),
                    'cAccount': ticket['customer_account'] ?? '',
                    'sAccount': ticket['supplier_account'] ?? '',
                    'paxName': ticket['pax_name'] ?? '',
                    'voucherNumber': ticket['voucher_number'] ?? '',
                    'saleAmount': _parseAmount(ticket['sale_amount']),
                    'purchaseAmount': _parseAmount(ticket['purchase_amount']),
                    'profitLoss': _parseAmount(ticket['profit_loss']),
                  })
              .toList() ??
          [],
    );
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateFormat inputFormat = DateFormat('EEE, dd MMM yyyy');
      final DateTime parsedDate = inputFormat.parse(dateStr);
      return inputFormat.format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  static int _parseAmount(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', ''))?.toInt() ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'summary': summary,
      'details': details,
    };
  }
}