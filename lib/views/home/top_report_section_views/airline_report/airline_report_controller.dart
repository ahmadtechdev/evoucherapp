import 'package:evoucher_new/service/api_service.dart';
import 'package:evoucher_new/views/home/top_report_section_views/airline_report/airline_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AirlineReportController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var selectedDate = DateTime.now().obs;
  var transactions = <AirLine>[].obs;
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
      isLoading.value = true;

      String formattedDate = DateFormat('yyyy-M-d').format(selectedDate.value);

      final response = await _apiService.postRequest(
          endpoint: 'accReports',
          body: {"date": formattedDate, "subhead": "Air Tickets Suppliers"});

      transactions.clear();

      if (response['status'] == 'success' &&
          response['data']['customers'] != null) {
        // Transform and filter API data
        transactions.value =
            (response['data']['customers'] as List).map((customer) {
          final debit = _parseAmount(customer['debit']);
          final credit = _parseAmount(customer['credit']);

          return AirLine(
              id: customer['account_id'],
              name: customer['account_name'],
              closingDr: debit,
              closingCr: credit,
              accountNumber: customer['cell']?.trim().isEmpty == true
                  ? null
                  : customer['cell']);
        }).where((airline) {
          // Only include airlines where either debit or credit is non-zero
          return airline.closingDr != 0 || airline.closingCr != 0;
        }).toList();

        // Calculate totals based on API response
        final totals = response['data']['totals'];
        totalReceipt.value = _parseAmount(totals['total_debit']);
        totalPayment.value = _parseAmount(totals['total_credit']);
        closingBalance.value = _parseAmount(totals['total_balance']);
      } else {
        // Handle invalid response
        Get.snackbar(
          'Error',
          'Invalid response format from server',
          snackPosition: SnackPosition.BOTTOM,
        );
        _resetValues();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transactions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      _resetValues();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to reset all values
  void _resetValues() {
    transactions.clear();
    totalReceipt.value = 0.0;
    totalPayment.value = 0.0;
    closingBalance.value = 0.0;
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
