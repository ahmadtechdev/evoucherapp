import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_service.dart';
import 'ledger_modal.dart';
import '../accounts/account_controller.dart'; // Import the account controller

class LedgerController extends GetxController {
  final ApiService apiService;

  LedgerController({required this.apiService});

  Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 90)).obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  final RxList<LedgerVoucher> vouchers = <LedgerVoucher>[].obs;
  final RxList<LedgerVoucher> filteredVouchers = <LedgerVoucher>[].obs;
  final Rx<LedgerMasterData?> masterData = Rx<LedgerMasterData?>(null);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchLedgerData(String accountId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.get(
        'account-ledger',
        queryParams: {
          'account_id': accountId,
          'from_date': DateFormat('yyyy-MM-dd').format(fromDate.value),
          'to_date': DateFormat('yyyy-MM-dd').format(toDate.value),
        },
      );

      if (response['status'] == 'success') {
        masterData.value = LedgerMasterData.fromJson(response['master_data']);

        vouchers.value = (response['vouchers'] as List)
            .map((json) => LedgerVoucher.fromJson(json))
            .toList();

        filteredVouchers.value = [...vouchers];
      } else {
        errorMessage.value = 'Failed to fetch ledger data';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    fromDate.value = from;
    toDate.value = to;
  }

  void searchTransactions(String query) {
    if (query.isEmpty) {
      filteredVouchers.value = [...vouchers];
    } else {
      filteredVouchers.value = vouchers.where((voucher) {
        return voucher.description
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            voucher.voucher.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  double calculateTotalDebit() {
    return filteredVouchers.fold(0, (sum, voucher) => sum + voucher.debit);
  }

  double calculateTotalCredit() {
    return filteredVouchers.fold(0, (sum, voucher) => sum + voucher.credit);
  }
}