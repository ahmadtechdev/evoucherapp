import 'package:get/get.dart';
import '../models/monthly_profit_loss_model.dart';

class MonthlyProfitLossController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final data = MonthlyProfitLossModel(
    name: 'Monthly Profit Loss',
    expenses: {
      '2024-01': {
        'Staff Salaries': 115000.0,
        'Fuel Allowance': 8500.0,
      },
      '2024-02': {
        'Staff Salary': 20000.0,
      },
      '2024-07': {
        'HUSSAIN ALI ISB EMP': 45000.0,
      },
      '2024-10': {
        'Discount': 2269970.0,
      },
    },
    incomes: {
      '2024-01': {
        'Package Income': 489457.0,
        'Ticket Income': 266113.0,
      },
      '2024-02': {
        'Hotel Incomes': 625221.0,
        'Visa Incomes': 134500.0,
      },
      '2024-03': {
        'Other Incomes': 81412.0,
      },
      '2024-04': {
        'Transport Income': 22210.0,
      },
    },
  ).obs;

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

  String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }
}