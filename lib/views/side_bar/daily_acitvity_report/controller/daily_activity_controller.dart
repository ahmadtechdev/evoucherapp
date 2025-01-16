// daily_activity_controller.dart
import 'package:evoucher/service/api_service.dart';
import 'package:get/get.dart';
import '../models/daily_activity_model.dart';

class DailyActivityReportController extends GetxController {
  final ApiService _apiService = ApiService();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var activities = <DailyActivityReportModel>[].obs;
  var isLoading = false.obs;
  var totalDebit = 0.0.obs;
  var totalCredit = 0.0.obs;
  var balance = 0.0.obs;
  var totalEntries = 0.obs;
  var dateRangeFrom = ''.obs;
  var dateRangeTo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fromDate.value = DateTime.now().subtract(Duration(days: 5));
    fetchDailyActivity();
  }

  String formatDateForApi(DateTime date) {
    // Format date as YYYY-MM-DD
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> fetchDailyActivity() async {
    try {
      isLoading.value = true;

      String formattedFromDate = formatDateForApi(fromDate.value);
      String formattedToDate = formatDateForApi(toDate.value);

      print('From Date: $formattedFromDate');
      print('To Date: $formattedToDate');

      final response = await _apiService.fetchDateRangeReport(
        endpoint: "dailyActivity",
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      if (response != null && response['status'] == 'success') {
        // Update activities
        final List activitiesData = response['data']['activities'];
        activities.value = activitiesData
            .map((data) => DailyActivityReportModel.fromJson(data))
            .toList();

        // Update totals
        final totals = response['data']['totals'];
        totalDebit.value = (totals['total_debit'] ?? 0).toDouble();
        totalCredit.value = (totals['total_credit'] ?? 0).toDouble();
        balance.value = (totals['balance'] ?? 0).toDouble();
        totalEntries.value = totals['entries'] ?? 0;

        // Update date range
        final dateRange = response['date_range'];
        dateRangeFrom.value = dateRange['from'] ?? '';
        dateRangeTo.value = dateRange['to'] ?? '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch daily activity: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
