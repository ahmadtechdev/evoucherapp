import 'package:get/get.dart';
import 'package:evoucher/service/api_service.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  final ApiService _apiService = ApiService();
  var transactions = [].obs;
  var isLoading = false.obs;
 var grandTotals = {
  'total_sales': '0.00',
  'total_purchases': '0.00',
  'total_profit_loss': '0.00'
}.obs;


  final RxList<bool> expandedStates = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions(
      fromDate: formatDate(DateTime.now().subtract(Duration(days: 30))),
      toDate: formatDate(DateTime.now()),
    );
  }

  // Helper function to safely parse string to double
  double parseAmount(String amount) {
    try {
      // Remove commas and any whitespace
      String cleanAmount = amount.replaceAll(',', '').trim();
      return double.parse(cleanAmount);
    } catch (e) {
      print('Error parsing amount: $amount');
      return 0.0;
    }
  }

  Future<void> fetchTransactions({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchDateRangeReport(
        endpoint: "allTicketVoucher",
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response['status'] == 'success') {
        final dailyRecords = response['data']['daily_records'] as List;
        transactions.value = dailyRecords.map((record) {
          return {
            'date': record['date'],
            'entries': record['totals']['total_rows'],
            'purchase': parseAmount(record['totals']['total_purchase_amount']),
            'sale': parseAmount(record['totals']['total_amount']),
            'profit': parseAmount(record['totals']['total_profit_loss']),
            'details': (record['tickets'] as List)
                .map((ticket) => {
                      'voucherNo': ticket['voucher_number'],
                      'customerAccount': ticket['customer_account'],
                      'supplierAccount': ticket['supplier_account'],
                      'paxName': ticket['pax_name'],
                      'pAmount': parseAmount(ticket['purchase_amount']),
                      'sAmount': parseAmount(ticket['sale_amount']),
                      'pnl': parseAmount(ticket['profit_loss']),
                    })
                .toList(),
          };
        }).toList();

        // Update grand totals
        final grandTotalData = response['data']['grand_totals'];
  grandTotals.value = {
    'total_sales': parseAmount(grandTotalData['total_sales'].toString()).toString(),
    'total_purchases': parseAmount(grandTotalData['total_purchases'].toString()).toString(),
    'total_profit_loss': parseAmount(grandTotalData['total_profit_loss'].toString()).toString(),
  };

        expandedStates.value = List.generate(transactions.length, (_) => false);
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpanded(int index) {
    expandedStates[index] = !expandedStates[index];
    expandedStates.refresh();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
