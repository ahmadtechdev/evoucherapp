
import 'package:evoucher_new/common_widget/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../service/api_service.dart';
import '../models/expense_item_modal.dart';
import 'package:intl/intl.dart';

class ExpenseReportController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final expenseItems = <ExpenseItemModel>[].obs;
  final isLoading = true.obs;
  final ApiService apiService = ApiService();
  final monthlyTotals = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    fromDate.value = DateTime(now.year, now.month, 1);
    toDate.value = DateTime(now.year, now.month, 1);
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    try {
      isLoading.value = true;

      // Format dates for API request
      String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate.value);
      String toDateStr = DateFormat('yyyy-MM-dd').format(toDate.value);

      // Prepare the request body
      final requestBody = {
        "fromDate": fromDateStr,
        "toDate": toDateStr,
        // Add any additional parameters if required by your API
      };

      // Make API call using postRequest
      final response = await apiService.postRequest(
        endpoint: 'expensesReport',
        body: requestBody,
      );

      if (response['status'] == 'success') {
        // Parse expense accounts
        final expenseAccounts = response['data']['expense_accounts'] as List;
        expenseItems.value = expenseAccounts.map((account) {
          final monthlyAmounts = (account['monthly_amounts'] as List).first;

          return ExpenseItemModel(
            name: account['account_name'],
            amount: (monthlyAmounts['amount']).toDouble(),
            total: account['total'].toDouble(),
          );
        }).toList();

        // Parse monthly totals
        monthlyTotals.value = (response['data']['monthly_totals'] as List)
            .map((e) => {
          'month': e['month'],
          'total': e['total'],
          'formatted_total': e['formatted_total']
        })
            .toList();
      }
    } catch (e) {
      // print('Error fetching expense  $e');

      CustomSnackBar(message:"Failed to load expense data. Please try again." ).show();
    } finally {
      isLoading.value = false;
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    fetchExpenseData();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    fetchExpenseData();
  }

  List<DateTime> getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate.value;
    while (current.isBefore(toDate.value) ||
        current.month == toDate.value.month &&
            current.year == toDate.value.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    return months;
  }

  String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  Color getColorForIndex(int index) {
    final colors = [
      Get.theme.primaryColor,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.deepPurple,
      Colors.orange
    ];
    return colors[index % colors.length];
  }
}
