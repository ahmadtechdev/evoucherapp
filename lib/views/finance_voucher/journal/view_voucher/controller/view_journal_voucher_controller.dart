// controllers/journal_voucher_controller.dart

import 'package:get/get.dart';

import '../../../../../service/api_service.dart';
import '../models/_view_journal_voucher_modal.dart';

class JournalVoucherController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<JournalVoucher> vouchers = <JournalVoucher>[].obs;
  final RxList<JournalVoucher> filteredVouchers = <JournalVoucher>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<DateTime> fromDate = DateTime.now().obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.postLogin(
        endpoint: 'getVoucherPosted',
        body: {
          "fromDate": fromDate.value.toString().split(' ')[0],
          "toDate": toDate.value.toString().split(' ')[0],
          "voucher_id": "",
          "voucher_type": "jv"
        },
      );

      if (response['status'] == 'success') {
        final List<dynamic> voucherData = response['data']['master'] ?? [];
        print(voucherData);
        vouchers.value = voucherData
            .map((data) => JournalVoucher.fromJson(data))
            .toList();
        filteredVouchers.value = vouchers;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch vouchers';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterVouchers(String query) {
    if (query.isEmpty) {
      filteredVouchers.value = vouchers;
    } else {
      filteredVouchers.value = vouchers
          .where((voucher) => voucher.description
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    fetchVouchers();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    fetchVouchers();
  }
}