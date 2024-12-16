import 'package:get/get.dart';

import '../models/daily_cash_activity_model.dart';

class DailyCashActivityController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var receivedTransactions = <DailyCashActivityModel>[].obs;
  var paidTransactions = <DailyCashActivityModel>[].obs;

  DailyCashActivityController() {
    // Load initial data
    loadTransactions();
  }

  void loadTransactions() {
    // Load your transactions here
    receivedTransactions.addAll([
      DailyCashActivityModel(voucherNo: 'CV 877', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
        DailyCashActivityModel(voucherNo: 'CV 877', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
        DailyCashActivityModel(voucherNo: 'CV 877', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
      // Add more as needed
    ]);

    paidTransactions.addAll([
      DailyCashActivityModel(voucherNo: 'CV 878', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
        DailyCashActivityModel(voucherNo: 'CV 878', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
        DailyCashActivityModel(voucherNo: 'CV 878', account: 'Afaq Travels', description: 'TEST', status: 'Posted', amount: '25.00'),
      // Add more as needed
    ]);
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void printReport() {
    // Implement print functionality
  }

  double get totalReceived => receivedTransactions.fold(0.0, (sum, item) => sum + double.parse(item.amount));
  double get totalPaid => paidTransactions.fold(0.0, (sum, item) => sum + double.parse(item.amount));
  double get closingBalance => totalReceived - totalPaid;
}