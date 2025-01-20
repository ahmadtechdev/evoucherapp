import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../models/monthly_profit_loss_model.dart';
import 'package:intl/intl.dart';

class MonthlyProfitLossController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final data = MonthlyProfitLossModel(
    name: 'Monthly Profit Loss',
    expenses: {},
    incomes: {},
  ).obs;

  final isLoading = false.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final response = await _apiService.postRequest(
        endpoint: 'monthlyProfitLoss',
        body: {
          "fromDate": DateFormat('yyyy-MM').format(fromDate.value),
          "toDate": DateFormat('yyyy-MM').format(toDate.value),
        },
      );

      // Transform API response to match MonthlyProfitLossModel format
      Map<String, Map<String, double>> expenses = {};
      Map<String, Map<String, double>> incomes = {};

      // Process expenses
      for (var expense in response['data']['expenses'] as List) {
        String accountName = expense['account_name'];
        Map<String, dynamic> monthlyAmounts = expense['monthly_amounts'];

        monthlyAmounts.forEach((month, amount) {
          // Convert month format from "Oct 2024" to "2024-10"
          final parsedDate = DateFormat('MMM yyyy').parse(month);
          final monthKey = DateFormat('yyyy-MM').format(parsedDate);

          if (amount > 0) { // Only add non-zero amounts
            expenses[monthKey] ??= {};
            expenses[monthKey]![accountName] = amount.toDouble();
          }
        });
      }

      // Process incomes
      for (var income in response['data']['incomes'] as List) {
        String accountName = income['account_name'];
        Map<String, dynamic> monthlyAmounts = income['monthly_amounts'];

        monthlyAmounts.forEach((month, amount) {
          // Convert month format from "Oct 2024" to "2024-10"
          final parsedDate = DateFormat('MMM yyyy').parse(month);
          final monthKey = DateFormat('yyyy-MM').format(parsedDate);

          if (amount != 0) { // Include both positive and negative amounts
            incomes[monthKey] ??= {};
            incomes[monthKey]![accountName] = amount.toDouble();
          }
        });
      }

      // Update the model
      data.value = MonthlyProfitLossModel(
        name: 'Monthly Profit Loss',
        expenses: expenses,
        incomes: incomes,
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch monthly profit loss  ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<DateTime> getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate.value;
    while (current.isBefore(toDate.value) ||
        current.month == toDate.value.month && current.year == toDate.value.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    return months;
  }

  String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    fetchData();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    fetchData();
  }
}