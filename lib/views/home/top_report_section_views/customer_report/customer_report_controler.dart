import 'package:evoucher_new/service/api_service.dart';
import 'package:evoucher_new/views/home/top_report_section_views/customer_report/model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerTransactionController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var selectedDate = DateTime.now().obs;
  var transactions = <CustomerTransaction>[].obs;
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
          body: {"date": formattedDate, "subhead": "Customers"});

      transactions.clear();

      if (response['status'] == 'success' &&
          response['data']['customers'] != null) {
        // Filter out customers with zero balances while transforming
        transactions.value =
            (response['data']['customers'] as List).map((customer) {
          final debit = _parseAmount(customer['debit']);
          final credit = _parseAmount(customer['credit']);

          return CustomerTransaction(
              id: customer['account_id'],
              name: customer['account_name'],
              closingDr: debit,
              closingCr: credit,
              contact: customer['cell']?.trim().isEmpty == true
                  ? null
                  : customer['cell']);
        }).where((transaction) {
          // Only include transactions where either debit or credit is non-zero
          return transaction.closingDr != 0 || transaction.closingCr != 0;
        }).toList();

        // Calculate totals based on filtered transactions
        final totals = response['data']['totals'];
        totalReceipt.value = _parseAmount(totals['total_debit']);
        totalPayment.value = _parseAmount(totals['total_credit']);
        closingBalance.value = _parseAmount(totals['total_balance']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      transactions.clear();
      totalReceipt.value = 0.0;
      totalPayment.value = 0.0;
      closingBalance.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

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

  void openWhatsApp(String contact) async {
    // Format the phone number by removing any non-digit characters
    String formattedNumber = contact.replaceAll(RegExp(r'[^0-9]'), '');

    // If the number doesn't start with a country code, add it (assuming '+91' for India)
    if (!formattedNumber.startsWith('+')) {
      if (!formattedNumber.startsWith('92')) {
        formattedNumber = '92$formattedNumber';
      }
    }

    // Create the WhatsApp URL
    final whatsappUrl = 'https://wa.me/$formattedNumber';

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        Get.snackbar(
          'Error',
          'WhatsApp is not installed on this device',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open WhatsApp: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
