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

  }


}