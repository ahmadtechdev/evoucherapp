// controllers/incomes_report_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IncomesReportController extends GetxController {
  final Rx<DateTime> fromDate = DateTime(2024, 1).obs;
  final Rx<DateTime> toDate = DateTime(2024, 11).obs;

  // You can add more reactive variables for the income data
  final RxList<Map<String, dynamic>> monthlyIncomes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data
    loadIncomeData();
  }

  void loadIncomeData() {
    // Here you would typically load data from your API or database
    // For now, we'll use dummy data
    // You can implement your actual data loading logic here
  }

  // ... (keep the previous methods)
  List<DateTime> getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate.value;
    while (current.isBefore(toDate.value) ||
        current.month == toDate.value.month && current.year == toDate.value.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    return months;
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }

  String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  String getFormattedDateRange() {
    return 'From ${DateFormat('MMM yyyy').format(fromDate.value)} To ${DateFormat('MMM yyyy').format(toDate.value)}';
  }

  double calculateTotalForMonth(DateTime month) {
    // Implement the logic to calculate total for a specific month
    return 0.0;
  }

  Map<String, double> calculateTotalSummary() {
    // Implement the logic to calculate summary totals
    return {};
  }
}