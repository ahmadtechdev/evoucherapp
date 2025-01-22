import 'package:evoucher_new/views/home/top_report_section_views/customer_report/model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerTransactionController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var transactions = <CustomerTransaction>[].obs;
  var totalReceipt = 0.0.obs;
  var totalPayment = 0.0.obs;
  var closingBalance = 0.0.obs;
  
  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() {
    // Dummy data - Replace with actual API call
    transactions.value = [
      CustomerTransaction(
        id: "472",
        name: "AHMED C/O MUNIR",
        closingDr: 0.00,
        closingCr: 654305.00,
        contact: "0575765707",
      ),
      CustomerTransaction(
        id: "490",
        name: "Ali Akbar R/O Munir",
        closingDr: 0.00,
        closingCr: 5000.00,
      ),
      // Add more dummy data
    ];
    calculateTotals();
  }

  void calculateTotals() {
    totalReceipt.value = transactions.fold(0, (sum, item) => sum + item.closingDr);
    totalPayment.value = transactions.fold(0, (sum, item) => sum + item.closingCr);
    closingBalance.value = totalReceipt.value - totalPayment.value;
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    // Here you would typically fetch new data based on the selected date
    loadTransactions();
  }

  void printReport() {
    // Implement print functionality
    Get.snackbar(
      'Print',
      'Printing report...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openLedger(String id) {
    // Implement ledger navigation
    Get.toNamed('/ledger/$id');
  }

  void openWhatsApp(String contact) {
    // Implement WhatsApp functionality
    Get.snackbar(
      'WhatsApp',
      'Opening WhatsApp chat...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}