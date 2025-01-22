import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BanksController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var banks = <Bank>[].obs;
  var totalReceipt = 0.0.obs;
  var totalPayment = 0.0.obs;
  var closingBalance = 0.0.obs;
  
  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  @override
  void onInit() {
    super.onInit();
    loadBanks();
  }

  void loadBanks() {
    // Dummy data
    banks.value = [
      Bank(
        id: "609",
        name: "AL BARKA BANK LIMITED",
        accountNumber: "0545885111",
        closingDr: 1300000.00,
        closingCr: 0.00,
      ),
      Bank(
        id: "597",
        name: "Alfalh Islamic Banking Limited",
        accountNumber: "0521883111",
        closingDr: 300000.00,
        closingCr: 0.00,
      ),
      // Add more dummy data
    ];
    calculateTotals();
  }

  void calculateTotals() {
    totalReceipt.value = banks.fold(0, (sum, bank) => sum + bank.closingDr);
    totalPayment.value = banks.fold(0, (sum, bank) => sum + bank.closingCr);
    closingBalance.value = totalReceipt.value - totalPayment.value;
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    loadBanks();
  }

  void printReport() {
    Get.snackbar(
      'Print',
      'Printing bank report...',
      backgroundColor: TColor.primary.withOpacity(0.1),
      colorText: TColor.primary,
    );
  }

  void openLedger(String id) {
    Get.toNamed('/bank-ledger/$id');
  }
}