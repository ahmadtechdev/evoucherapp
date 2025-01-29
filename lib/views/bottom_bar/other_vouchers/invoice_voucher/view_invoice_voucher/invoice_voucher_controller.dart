import 'package:evoucher_new/service/api_service.dart';
import 'package:get/get.dart';

class InvoiceVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  var ticketVouchers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for API request

      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'ViewInvoiceVoucher', fromDate: '', toDate: '',
      );

      if (response['status'] == 'success') {
        final List<Map<String, dynamic>> formattedVouchers =
        (response['data']['vouchers'] as List)
            .map((voucher) => {
          'VV_ID': 'IV ${voucher['voucher_id']}',
          'debit_account': voucher['debit_account'],
          'credit_account': voucher['credit_account'],
          'added_by': voucher['added_by'],
          'date': voucher['date'],
          'entries_count': voucher['entries_count'],
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
