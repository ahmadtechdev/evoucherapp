import 'package:evoucher_new/service/api_service.dart';
import 'package:evoucher_new/views/home/top_report_section_views/airline_report/airline_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AirlineReportController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var selectedDate = DateTime.now().obs;
  var transactions = <ariline>[].obs;
  var totalReceipt = 0.0.obs;
  var totalPayment = 0.0.obs;
  var closingBalance = 0.0.obs;
  var isLoading = false.obs;

  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

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
          body: {"date": formattedDate, "subhead": "Air Tickets Suppliers"});

      // Clear existing transactions
      transactions.clear();

      // Parse API response
      if (response['status'] == 'success' &&
          response['data']['customers'] != null) {
        // Transform API data to CustomerTransaction
        transactions.value =
            (response['data']['customers'] as List).map((customer) {
          return ariline(
              id: customer['account_id'],
              name: customer['account_name'],
              closingDr: _parseAmount(customer['debit']),
              closingCr: _parseAmount(customer['credit']),
              accountNumber: customer['cell']?.trim().isEmpty == true
                  ? null
                  : customer['cell']);
        }).toList();

        // Calculate totals based on API response
        final totals = response['data']['totals'];
        totalReceipt.value = _parseAmount(totals['total_debit']);
        totalPayment.value = _parseAmount(totals['total_credit']);
        closingBalance.value = _parseAmount(totals['total_balance']);
      }
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      // Optionally, set some default or empty state
      transactions.clear();
      totalReceipt.value = 0.0;
      totalPayment.value = 0.0;
      closingBalance.value = 0.0;
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
