import 'package:evoucher_new/service/api_service.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/session_manager.dart';

class BanksController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var selectedDate = DateTime.now().obs;
  var transactions = <Bank>[].obs;
  var totalReceipt = 0.0.obs;
  var totalPayment = 0.0.obs;
  var closingBalance = 0.0.obs;
  var isLoading = false.obs;
  String? loginType;
  String subhead = "Banks";

  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  @override
  void onInit() {
    super.onInit();
    // Initialize controller with async operation
    initializeController();
  }

  Future<void> initializeController() async {
    try {
      isLoading.value = true;
      await _initializeLoginType();
      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to initialize: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initializeLoginType() async {
    final sessionManager = Get.find<SessionManager>();
    loginType = await sessionManager.getLoginType();
    // Set subhead based on loginType immediately after getting it
    subhead = loginType == "toc" ? "Travelocity Bank Accounts" : "Banks";
  }

  Future<void> loadTransactions() async {
    if (loginType == null) {
      await _initializeLoginType();
    }

    try {
      isLoading.value = true;

      String formattedDate = DateFormat('yyyy-M-d').format(selectedDate.value);

      final response = await _apiService.postRequest(
          endpoint: 'accReports',
          body: {"date": formattedDate, "subhead": subhead});

      transactions.clear();

      if (response == null || response['status'] != 'success') {
        throw 'Failed to load transactions: Invalid response';
      }

      if (response['data']['customers'] != null) {
        // Transform and filter API data
        transactions.value =
            (response['data']['customers'] as List).map((customer) {
          final debit = _parseAmount(customer['debit']);
          final credit = _parseAmount(customer['credit']);

          return Bank(
              id: customer['account_id'],
              name: customer['account_name'],
              closingDr: debit,
              closingCr: credit,
              accountNumber: customer['cell']?.trim().isEmpty == true
                  ? null
                  : customer['cell']);
        }).where((bank) {
          // Only include banks where either debit or credit is non-zero
          return bank.closingDr != 0 || bank.closingCr != 0;
        }).toList();

        // Calculate totals based on API response
        final totals = response['data']['totals'];
        totalReceipt.value = _parseAmount(totals['total_debit']);
        totalPayment.value = _parseAmount(totals['total_credit']);
        closingBalance.value = _parseAmount(totals['total_balance']);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transactions: ${e.toString()}',
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

  Future<void> updateDate(DateTime date) async {
    selectedDate.value = date;
    await loadTransactions();
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
