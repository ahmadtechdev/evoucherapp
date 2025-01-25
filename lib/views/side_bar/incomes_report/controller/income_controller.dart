
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';

class IncomesReportController extends GetxController {
  final ApiService _apiService = ApiService();
  final Rx<DateTime> fromDate = DateTime.now().obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Reactive variables for the income data
  final RxMap<String, dynamic> incomeData = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadIncomeData();
  }

  Future<void> loadIncomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for API request
      String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate.value);
      String toDateStr = DateFormat('yyyy-MM-dd').format(toDate.value);

      // Prepare the request body
      final requestBody = {
        "fromDate": fromDateStr,
        "toDate": toDateStr,
        // Add any additional parameters if required by your API
      };

      // Make API request using postRequest
      final response = await _apiService.postRequest(
        endpoint: "incomesReport",
        body: requestBody,
      );

      if (response['status'] == 'success') {
        incomeData.value = response['data'];
      } else {
        errorMessage.value = 'Failed to load income data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    loadIncomeData();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    loadIncomeData();
  }

  List<DateTime> getMonthsBetween() {
    if (incomeData.isEmpty || !incomeData.containsKey('monthly_totals')) {
      return [];
    }

    return (incomeData['monthly_totals'] as List)
        .map((total) => DateFormat('MMM yyyy').parse(total['month']))
        .toList();
  }

  String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  String getFormattedDateRange() {
    if (incomeData.isEmpty || !incomeData.containsKey('date_range')) {
      return '';
    }
    return 'From ${incomeData['date_range']['from']} To ${incomeData['date_range']['to']}';
  }

  Map<String, dynamic> getIncomeDataForMonth(String month) {
    if (incomeData.isEmpty || !incomeData.containsKey('income_accounts')) {
      return {};
    }

    Map<String, dynamic> monthData = {};
    for (var account in incomeData['income_accounts']) {
      var monthlyAmount = account['monthly_amounts']
          .firstWhere((m) => m['month'] == month, orElse: () => null);

      if (monthlyAmount != null) {
        monthData[account['account_name']] = {
          'amount': monthlyAmount['formatted_amount'],
          'total': account['total'].toString(),
          'is_negative': monthlyAmount['is_negative']
        };
      }
    }
    return monthData;
  }

  String getTotalForMonth(String month) {
    if (incomeData.isEmpty || !incomeData.containsKey('monthly_totals')) {
      return '0.00';
    }

    var monthTotal = (incomeData['monthly_totals'] as List)
        .firstWhere((m) => m['month'] == month, orElse: () => null);
    return monthTotal != null ? monthTotal['formatted_total'] : '0.00';
  }

  Map<String, String> getTotalSummary() {
    if (incomeData.isEmpty || !incomeData.containsKey('income_accounts')) {
      return {};
    }

    Map<String, String> totals = {};
    for (var account in incomeData['income_accounts']) {
      totals[account['account_name']] =
          NumberFormat('#,##0.00').format(account['total']);
    }
    return totals;
  }
}
