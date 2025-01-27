import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';
import '../models/daily_cash_book_model.dart';

class DailyCashBookController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());
  var selectedDate = DateTime.now().obs;
  var transactions = <DailyCashBookModel>[].obs;
  var filteredTransactions = <DailyCashBookModel>[].obs;
  var isLoading = false.obs;
  var openingBalance = ''.obs;
  var totalReceipt = ''.obs;
  var totalPayment = ''.obs;
  var closingBalance = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDailyCashBook();

    // Listen to search query changes
    ever(searchQuery, (_) => _filterTransactions());
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _filterTransactions() {
    if (searchQuery.value.isEmpty) {
      // ignore: invalid_use_of_protected_member
      filteredTransactions.value = transactions.value;
    } else {
      // ignore: invalid_use_of_protected_member
      filteredTransactions.value = transactions.value.where((transaction) {
        return transaction.description
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Update summary values based on filtered transactions
    _updateSummaryValues();
  }

  void _updateSummaryValues() {
    // Recalculate summary values based on filtered transactions
    double totalRcpt = filteredTransactions.fold(0, (sum, transaction) => sum + transaction.credit);
    double totalPymt = filteredTransactions.fold(0, (sum, transaction) => sum + transaction.debit);

    totalReceipt.value = totalRcpt.toStringAsFixed(2);
    totalPayment.value = totalPymt.toStringAsFixed(2);
    // You might want to adjust closing balance calculation based on your business logic
    closingBalance.value = (totalRcpt - totalPymt).toStringAsFixed(2);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
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

        // Initialize filtered transactions with all transactions
        // ignore: invalid_use_of_protected_member
        filteredTransactions.value = transactions.value;
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
    searchQuery.value = ''; // Reset search query
  }
}