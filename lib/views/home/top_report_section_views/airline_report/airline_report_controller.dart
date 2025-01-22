import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/views/home/top_report_section_views/airline_report/airline_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AirlineReportController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var airline = <ariline>[].obs;
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
    airline.value = [
      ariline(
        id: "609",
        name: "AL BARKA ariline LIMITED",
        accountNumber: "0545885111",
        closingDr: 1300000.00,
        closingCr: 0.00,
      ),
      ariline(
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
    totalReceipt.value = airline.fold(0, (sum, bank) => sum + bank.closingDr);
    totalPayment.value = airline.fold(0, (sum, bank) => sum + bank.closingCr);
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