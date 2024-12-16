import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/daily_activity_model.dart';

class DailyActivityReportController extends GetxController {
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs();

  // Dummy data
  var activities = <DailyActivityReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    activities.addAll([
      DailyActivityReportModel(voucherNo: 'CV 877', date: DateTime.now(), account: 'Afaq Travels', description: 'TEST', debit: 25.00, credit: 0.00),
      DailyActivityReportModel(voucherNo: 'CV 878', date: DateTime.now(), account: 'Cash', description: 'TEST', debit: 0.00, credit: 25.00),
      // Add more dummy data as needed
    ]);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}