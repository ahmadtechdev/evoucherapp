import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';
import '../models/ledger_modal.dart';

class LedgerController extends GetxController {
  final String accountId;
  final String accountName;

  LedgerController({
    required this.accountId,
    required this.accountName
  });

  // Observable variables
  final Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 90)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;
  final RxList<LedgerVoucher> vouchers = <LedgerVoucher>[].obs;
  final RxList<LedgerVoucher> filteredVouchers = <LedgerVoucher>[].obs;
  final Rx<LedgerMasterData?> masterData = Rx<LedgerMasterData?>(null);
  final ApiService apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLedgerData();
  }

  Future<void> fetchLedgerData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.fetchAccountLedger(
        accountId: accountId,
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate.value),
        toDate: DateFormat('yyyy-MM-dd').format(toDate.value),
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
    fetchLedgerData();
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