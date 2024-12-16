import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/daily_cash_book_model.dart';


class DailyCashBookController extends GetxController {
  var selectedDate = DateTime.now().obs;

  // Dummy data
  var transactions = <DailyCashBookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    transactions.addAll([
      DailyCashBookModel(id: '877', date: DateTime.now(), description: 'Salary Payment', receipt: 5000.00, payment: 0.00, balance: 44901.00),
      DailyCashBookModel(id: '878', date: DateTime.now(), description: 'Office Supplies', receipt: 0.00, payment: 1500.00, balance: 43401.00),
      // Add more dummy data as needed
    ]);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Method to calculate totals
  double get totalReceipt => transactions.fold(0, (sum, item) => sum + item.receipt);
  double get totalPayment => transactions.fold(0, (sum, item) => sum + item.payment);
  double get closingBalance => transactions.isNotEmpty ? transactions.last.balance : 0.0;


}