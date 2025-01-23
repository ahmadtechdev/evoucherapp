import 'package:evoucher_new/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentReportController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var selectedDate = DateTime.now().obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var totals = {
    'totalDebit': 0.0.obs,
    'totalCredit': 0.0.obs,
    'totalBalance': 0.0.obs
  };
  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() async {
    try {
      // Set loading to true
      isLoading.value = true;

      // Format date to match API requirement
      String formattedDate = DateFormat('yyyy-M-d').format(selectedDate.value);
      final response = await _apiService.postRequest(
          endpoint: 'accReports',
          body: {"date": formattedDate, "subhead": "TRAVEL AGENTS"});

      if (response['status'] == 'success' && response['data'] != null) {
        // Transform API data to match the existing transaction structure
        transactions.value = (response['data']['customers'] as List)
            .map((customer) => {
          'date': response['date'],
          'name': customer['account_name'],
          'email': customer['cell'],
          'receipt':
          double.parse(customer['credit'].replaceAll(',', '')),
          'payment':
          double.parse(customer['debit'].replaceAll(',', '')),
          'balance': double.parse(
              customer['balance']['amount'].replaceAll(',', ''))
        })
            .toList();

        // Update totals
        totals['totalDebit']!.value = double.parse(
            response['data']['totals']['total_debit'].replaceAll(',', ''));
        totals['totalCredit']!.value = double.parse(
            response['data']['totals']['total_credit'].replaceAll(',', ''));
        totals['totalBalance']!.value = double.parse(
            response['data']['totals']['total_balance'].replaceAll(',', ''));
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      // Handle error - perhaps show a snackbar or toast
    } finally {
      // Set loading to false
      isLoading.value = false;
    }
  }

  // Helper method to parse amount strings with commas
  double _parseAmount(String? amount) {
    if (amount == null || amount.isEmpty) return 0.0;
    return double.parse(amount.replaceAll(',', ''));
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    loadTransactions();
  }

  void printReport() {
    // Implement print functionality
    Get.snackbar(
      'Print',
      'Printing report...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openLedger(String id) {
    // Implement ledger navigation
    Get.toNamed('/ledger/$id');
  }

  void openWhatsApp(String contact) {
    // Implement WhatsApp functionality
    Get.snackbar(
      'WhatsApp',
      'Opening WhatsApp chat...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
