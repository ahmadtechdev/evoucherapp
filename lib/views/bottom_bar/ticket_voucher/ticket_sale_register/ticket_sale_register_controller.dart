
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';

class TicketSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate =
      DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for ticket data
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
    fetchTicketSaleRegisterData();
  }

  // Fetch ticket sale register data
  Future<void> fetchTicketSaleRegisterData() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = null;

      // Format dates for API
      final String formattedFromDate =
          DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate =
          DateFormat('yyyy-MM-dd').format(toDate.value);

      // Call API
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'ticketSaleRegister',
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      // Update data
      if (response['status'] == 'success') {
        dailyRecords.value = response['data']['daily_records'] ?? [];

        // Calculate and update totals
        // ignore: invalid_use_of_protected_member
        _calculateTotalSummary(dailyRecords.value);
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

  // Calculate total summary from daily records
  void _calculateTotalSummary(List<dynamic> records) {
    int totalRows = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfitLoss = 0;

    for (var dailyRecord in records) {
      if (dailyRecord['tickets'] != null) {
        final tickets = dailyRecord['tickets'] as List;
        totalRows += tickets.length;

        for (var ticket in tickets) {
          // Parse buying amount
          final buyingAmount = double.tryParse(
                  ticket['buying_amount'].toString().replaceAll(',', '')) ??
              0;
          totalBuying += buyingAmount;

          // Parse selling amount
          final sellingAmount = double.tryParse(
                  ticket['selling_amount'].toString().replaceAll(',', '')) ??
              0;
          totalSelling += sellingAmount;

          // Parse profit/loss amount
          if (ticket['profit_loss'] != null) {
            final profitLossAmount = double.tryParse(ticket['profit_loss']
                        ['amount']
                    .toString()
                    .replaceAll(',', '')) ??
                0;
            totalProfitLoss += profitLossAmount;
          }
        }
      }
    }

    // Update total summary
    totalSummary.value = {
      'total_rows': totalRows,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit_loss': NumberFormat('#,##0.00').format(totalProfitLoss)
    };
  }

  // Update date range and refresh data
  void updateDateRange(DateTime start, DateTime end) {
    fromDate.value = start;
    toDate.value = end;
    fetchTicketSaleRegisterData();
  }
}
