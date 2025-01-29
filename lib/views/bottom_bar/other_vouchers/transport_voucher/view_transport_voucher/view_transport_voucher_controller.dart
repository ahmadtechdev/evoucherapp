import 'package:evoucher_new/service/api_service.dart';
import 'package:get/get.dart';

class ViewTransportVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  var ticketVouchers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var totalRecords = 0.obs;
  var totalAmount = "0.00".obs;

  @override
  void onInit() {
    fromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    super.onInit();
    fetchTicketVouchers();
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> fetchTicketVouchers() async {
    try {
      isLoading.value = true;

      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'viewTransportVouchers',
        fromDate: formatDate(fromDate.value),
        toDate: formatDate(toDate.value),
      );

      if (response['status'] == 'success' && response['data'] != null) {
        // Transform API data into the format expected by the UI
        final List<Map<String, dynamic>> transformedVouchers =
        (response['data']['vouchers'] as List).map((voucher) {
          return {
            'voucher_id': voucher['voucher_id'] ?? '',
            'formatted_date': voucher['date'] ?? '',
            'description': voucher['description'] ?? '',
            'added_by': voucher['added_by'] ?? 'N/A',
            'selling_amount':
            voucher['amount']?['value']?.toString().replaceAll(',', '') ??
                '0.00',
            'needs_attention': false, // Add any logic for this if needed
          };
        }).toList();

        ticketVouchers.value = transformedVouchers;
        totalRecords.value = response['data']['totals']?['total_vouchers'] ?? 0;
        totalAmount.value =
            response['data']['totals']?['total_amount']?.toString() ?? "0.00";
      } else {
        throw 'Invalid response format or missing data';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch ticket vouchers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Clear the data in case of error to avoid showing stale data
      ticketVouchers.clear();
      totalRecords.value = 0;
      totalAmount.value = "0.00";
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    if (from.isAfter(to)) {
      Get.snackbar(
        'Error',
        'Start date cannot be after end date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    fromDate.value = from;
    toDate.value = to;
    fetchTicketVouchers();
  }

  // Helper method to format currency values
  String formatCurrency(String amount) {
    try {
      final value = double.parse(amount.replaceAll(',', ''));
      return value.toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }
}
