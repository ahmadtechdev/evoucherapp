import 'package:get/get.dart';
import 'package:evoucher/service/api_service.dart';

class TicketVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  var ticketVouchers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var totalRecords = 0.obs;

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
          endpoint: 'allVouchers',
          fromDate: formatDate(fromDate.value),
          toDate: formatDate(toDate.value),
          additionalParams: {'voucherType': 'tv'});

      if (response['status'] == 'success') {
        ticketVouchers.value =
            List<Map<String, dynamic>>.from(response['data']);
        totalRecords.value = response['total_records'] ?? 0;
      } else {
        throw 'Failed to fetch ticket vouchers';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch ticket vouchers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    fromDate.value = from;
    toDate.value = to;
    fetchTicketVouchers();
  }
}
