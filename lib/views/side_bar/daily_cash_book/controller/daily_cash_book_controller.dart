import 'package:evoucher/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/daily_cash_book_model.dart';

// daily_cash_book_controller.dart
class DailyCashBookController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var selectedDate = DateTime.now().obs;
  var transactions = <DailyCashBookModel>[].obs;
  var isLoading = false.obs;
  var openingBalance = ''.obs;
  var totalReceipt = ''.obs;
  var totalPayment = ''.obs;
  var closingBalance = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDailyCashBook();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> fetchDailyCashBook() async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        endpoint: 'dailyCashBook',
        body: {
          "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        },
      );

      if (response['status'] == 'success') {
        openingBalance.value = response['opening_balance'];
        totalReceipt.value = response['total_receipt'];
        totalPayment.value = response['total_payment'];
        closingBalance.value = response['closing_balance'];

        final List<dynamic> data = response['data'];
        transactions.value = data
            .map((item) => DailyCashBookModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch daily cash book data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update data when date changes
  void onDateChanged(DateTime newDate) {
    selectedDate.value = newDate;
    fetchDailyCashBook();
  }
}