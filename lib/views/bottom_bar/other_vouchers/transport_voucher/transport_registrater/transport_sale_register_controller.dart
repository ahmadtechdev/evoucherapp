import 'package:evoucher_new/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransportSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate =
      DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for visa data
  final RxList<dynamic> dailyRecords = <dynamic>[].obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Total summary with default values
  final Rx<Map<String, dynamic>> totalSummary = Rx<Map<String, dynamic>>({
    'total_count': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit': '0.00'
  });

  @override
  void onInit() {
    super.onInit();
    fetchVisaSaleRegisterData();
  }

  Future<void> fetchVisaSaleRegisterData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final String formattedFromDate =
          DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate =
          DateFormat('yyyy-MM-dd').format(toDate.value);

      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'visaSaleRegister',
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      if (response['status'] == 'success') {
        dailyRecords.value = response['data']['daily_records'] ?? [];
        // ignore: invalid_use_of_protected_member
        _calculateTotalSummary(dailyRecords.value);
      } else {
        errorMessage.value = 'Failed to fetch data';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotalSummary(List<dynamic> records) {
    int totalCount = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfit = 0;

    for (var dailyRecord in records) {
      if (dailyRecord['entries'] != null) {
        final entries = dailyRecord['entries'] as List;
        totalCount += entries.length;

        for (var entry in entries) {
          totalBuying += entry['buying'] ?? 0;
          totalSelling += entry['selling'] ?? 0;
          totalProfit += entry['profit_loss'] ?? 0;
        }
      }
    }

    totalSummary.value = {
      'total_count': totalCount,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit': NumberFormat('#,##0.00').format(totalProfit)
    };
  }

  void updateDateRange(DateTime start, DateTime end) {
    fromDate.value = start;
    toDate.value = end;
    fetchVisaSaleRegisterData();
  }
}
