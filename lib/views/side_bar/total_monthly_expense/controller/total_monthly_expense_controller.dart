import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';
import '../models/total_monthly_expense_model.dart';

class TotalMonthlyExpensesController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final companies = <TotalMonthlyExpensesModel>[].obs;
  final isLoading = false.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Format dates for API request
      final fromDateStr = DateFormat('yyyy-MM-dd')
          .format(DateTime(fromDate.value.year, fromDate.value.month, 1));
      final toDateStr = DateFormat('yyyy-MM-dd')
          .format(DateTime(toDate.value.year, toDate.value.month + 1, 0));

      // Make API request
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'totalExpensesReport',
        fromDate: fromDateStr,
        toDate: toDateStr,
      );

      if (response['status'] == 'success') {
        final branchesData =
            response['data']['branches'] as Map<String, dynamic>;

        // Transform API data into our model
        final List<TotalMonthlyExpensesModel> newCompanies = [];

        branchesData.forEach((branchName, branchData) {
          newCompanies.add(
            TotalMonthlyExpensesModel.fromApiData(
                branchName, branchData as Map<String, dynamic>),
          );
        });

        companies.value = newCompanies;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load expenses  ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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

  String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  double calculateCompanyTotalForMonth(
      TotalMonthlyExpensesModel company, String monthKey) {
    final monthExpenses = company.getExpensesForMonth(monthKey);
    return monthExpenses.values.fold(0.0, (sum, value) => sum + value);
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    loadData();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    loadData();
  }

  double calculateTotalExpenses() {
    return companies.fold(
        0.0, (sum, company) => sum + company.getTotalExpenses());
  }
}
