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

  // Helper method to parse amount strings with commas
  double _parseAmount(String? amount) {
    if (amount == null || amount.isEmpty) return 0.0;
    try {
      return double.parse(amount.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }

  void loadTransactions() async {
    try {
      isLoading.value = true;

      String formattedDate = DateFormat('yyyy-M-d').format(selectedDate.value);
      final response = await _apiService.postRequest(
          endpoint: 'accReports',
          body: {"date": formattedDate, "subhead": "TRAVEL AGENTS"});

      // Clear existing transactions
      transactions.clear();

      if (response['status'] == 'success' && response['data'] != null) {
        // Transform and filter API data
        final transformedTransactions =
            (response['data']['customers'] as List).map((customer) {
          final receipt = _parseAmount(customer['credit']);
          final payment = _parseAmount(customer['debit']);
          final balance = _parseAmount(customer['balance']['amount']);

          return {
            'date': response['date'],
            'name': customer['account_name'],
            'email': customer['cell'],
            'receipt': receipt,
            'payment': payment,
            'balance': balance,
          };
        }).where((transaction) {
          // Only include transactions where either payment or receipt is non-zero
          return transaction['payment'] != 0 || transaction['receipt'] != 0;
        }).toList();

        transactions.value = transformedTransactions;

        // Update totals from the API response
        final apiTotals = response['data']['totals'];
        totals['totalDebit']!.value = _parseAmount(apiTotals['total_debit']);
        totals['totalCredit']!.value = _parseAmount(apiTotals['total_credit']);
        totals['totalBalance']!.value =
            _parseAmount(apiTotals['total_balance']);
      } else {
        // Handle invalid response
        Get.snackbar(
          'Error',
          'Invalid response format from server',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Handle error with specific message
      Get.snackbar(
        'Error',
        'Failed to load transactions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reset values on error
      transactions.clear();
      totals['totalDebit']!.value = 0.0;
      totals['totalCredit']!.value = 0.0;
      totals['totalBalance']!.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    loadTransactions();
  }

  void printReport() {
    Get.snackbar(
      'Print',
      'Printing report...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openLedger(String id) {
    Get.toNamed('/ledger/$id');
  }

  void openWhatsApp(String contact) {
    Get.snackbar(
      'WhatsApp',
      'Opening WhatsApp chat...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
