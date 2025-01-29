
import 'package:get/get.dart';

import '../../../../service/api_service.dart';

class VisaVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  var ticketVouchers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var toDate = DateTime.now().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
     fromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for API request
      String fromDateStr = "${fromDate.value.year}-${fromDate.value.month.toString().padLeft(2, '0')}-${fromDate.value.day.toString().padLeft(2, '0')}";
      String toDateStr = "${toDate.value.year}-${toDate.value.month.toString().padLeft(2, '0')}-${toDate.value.day.toString().padLeft(2, '0')}";

      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'allVouchers',
        fromDate: fromDateStr,
        toDate: toDateStr,
        additionalParams: {"voucherType": "vv"},
      );

      if (response['status'] == 'success') {
        final List<Map<String, dynamic>> formattedVouchers = (response['data'] as List)
            .map((voucher) => {
                  'VV_ID': 'VV ${voucher['voucher_id']}',
                  'customer': voucher['details']['customer_account'],
                  'description': voucher['details']['description'],
                  'supplier': voucher['details']['supplier_account'],
                  'added_by': voucher['added_by'],
                  'visa_status': voucher['visa_status']['text'],
                  'price': voucher['details']['selling_amount'],
                  'date': voucher['formatted_date'],
                  'needs_attention': voucher['needs_attention'],
                  'changes_by': voucher['changes_by'],
                  'assign_status': voucher['assign_status']['text'],
                })
            .toList();

        ticketVouchers.value = formattedVouchers;
      } else {
        errorMessage.value = 'Failed to load vouchers';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    fromDate.value = from;
    toDate.value = to;
    fetchVouchers();
  }
}