import 'package:evoucher/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/daily_cash_activity_model.dart';

class DailyCashActivityController extends GetxController {
  final ApiService _apiService = ApiService();

  var selectedDate = DateTime.now().obs;
  var receivedTransactions = <DailyCashActivityModel>[].obs;
  var paidTransactions = <DailyCashActivityModel>[].obs;
  var openingBalance = "".obs;
  var totalReceivedAmount = "".obs;
  var totalPaidAmount = "".obs;
  var closingBalanceAmount = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await _apiService.postRequest(
        endpoint: 'dailyCashActivity',
        body: {"date": formattedDate},
      );

      if (response['status'] == 'success') {
        receivedTransactions.clear();
        paidTransactions.clear();

        final receivedList = (response['received'] as List? ?? [])
            .map((item) => DailyCashActivityModel.fromJson(item))
            .toList();
        final paidList = (response['paid'] as List? ?? [])
            .map((item) => DailyCashActivityModel.fromJson(item))
            .toList();

        receivedTransactions.addAll(receivedList);
        paidTransactions.addAll(paidList);

        // Update summary values
        openingBalance.value = response['opening_balance'] ?? "0";
        totalReceivedAmount.value =
            response['total_received']?.toString() ?? "0";
        totalPaidAmount.value = response['total_paid']?.toString() ?? "0";
        closingBalanceAmount.value =
            response['closing_balance']?.toString() ?? "0";
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transactions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    loadTransactions();
  }

  void printReport() {
    // Implement print functionality
  }
}
