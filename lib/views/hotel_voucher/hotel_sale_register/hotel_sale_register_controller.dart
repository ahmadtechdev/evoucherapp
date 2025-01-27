

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_service.dart';

class HotelSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for booking data
  final RxList<dynamic> dailyRecords = <dynamic>[].obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Total summary with default values
  final Rx<Map<String, dynamic>> totalSummary = Rx<Map<String, dynamic>>({
    'total_rows': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit_loss': '0.00'
  });

  @override
  void onInit() {
    super.onInit();
    // Fetch data when controller is initialized
    fetchHotelSaleRegisterData();
  }

  // Fetch hotel sale register data
  Future<void> fetchHotelSaleRegisterData() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = null;

      // Format dates for API
      final String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate.value);

      // Call API
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'hotelSaleRegister',
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      // Update data
      if (response['status'] == 'success') {
        dailyRecords.value = response['data']['daily_records'] ?? [];

        // Ensure totals are properly set with default values
        totalSummary.value = {
          'total_rows': response['data']['totals']?['total_rows'] ?? 0,
          'total_buying': response['data']['totals']?['total_buying'] ?? '0.00',
          'total_selling': response['data']['totals']?['total_selling'] ?? '0.00',
          'total_profit_loss': response['data']['totals']?['total_profit_loss'] ?? '0.00'
        };
      } else {
        errorMessage.value = 'Failed to fetch data';
      }
    } catch (e) {
      // Handle errors
      errorMessage.value = e.toString();
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Update date range and refresh data
  void updateDateRange(DateTime start, DateTime end) {
    fromDate.value = start;
    toDate.value = end;
    fetchHotelSaleRegisterData();
  }
}