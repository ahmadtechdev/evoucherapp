import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_service.dart';

class HotelVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var vouchers = <Map<String, dynamic>>[].obs;
  var fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'allVouchers',
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate.value),
        toDate: DateFormat('yyyy-MM-dd').format(toDate.value),
        additionalParams: {'voucherType': 'hv'},
      );

      if (response['status'] == 'success') {
        // Transform the data to match our UI structure
        final List<Map<String, dynamic>> transformedData =
            (response['data'] as List).map((voucher) {
          return {
            'hv_id': 'HV ${voucher['voucher_id']}',
            'customer': voucher['details']['customer_account'],
            'description': voucher['details']['description'],
            'supplier': voucher['details']['supplier_account'],
            'added_by': voucher['added_by'],
            'price': voucher['details']['selling_amount'],
            'date': voucher['formatted_date'],
            'needs_attention': voucher['needs_attention'],
            'is_refunded': voucher['refunded'] == '1',
          };
        }).toList();

        vouchers.value = transformedData;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load vouchers';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    fromDate.value = from;
    toDate.value = to;
    fetchVouchers();
  }

  double get totalAmount {
    return vouchers.fold(0.0, (sum, voucher) {
      return sum + double.parse(voucher['price'].toString());
    });
  }
}
