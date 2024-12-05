import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Activity {
  final String voucherNo;
  final DateTime date;
  final String account;
  final String description;
  final double debit;
  final double credit;

  Activity({
    required this.voucherNo,
    required this.date,
    required this.account,
    required this.description,
    required this.debit,
    required this.credit,
  });
}

class DailyActivityReportController extends GetxController {
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs();

  // Dummy data
  var activities = <Activity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    activities.addAll([
      Activity(voucherNo: 'CV 877', date: DateTime.now(), account: 'Afaq Travels', description: 'TEST', debit: 25.00, credit: 0.00),
      Activity(voucherNo: 'CV 878', date: DateTime.now(), account: 'Cash', description: 'TEST', debit: 0.00, credit: 25.00),
      // Add more dummy data as needed
    ]);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}