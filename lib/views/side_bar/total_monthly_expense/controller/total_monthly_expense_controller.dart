import 'package:get/get.dart';
import '../models/total_monthly_expense_model.dart';

class TotalMonthlyExpensesController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final companies = <TotalMonthlyExpensesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    // Sample data based on your request, with dummy data for each month
    companies.value = [
      TotalMonthlyExpensesModel(
        name: 'travel High',
        expenses: {
          '2024-01': {'Dummy Expense': 500.0},
          '2024-02': {'Dummy Expense': 500.0},
          '2024-03': {'Dummy Expense': 500.0},
          '2024-04': {'Dummy Expense': 500.0},
          '2024-05': {'Dummy Expense': 500.0},
          '2024-06': {'Dummy Expense': 500.0},
          '2024-07': {'Dummy Expense': 500.0},
          '2024-08': {'Dummy Expense': 500.0},
          '2024-09': {'Dummy Expense': 500.0},
          '2024-10': {'Dummy Expense': 500.0},
          '2024-11': {'Dummy Expense': 500.0},
          '2024-12': {'Dummy Expense': 500.0},
        },
      ),
      TotalMonthlyExpensesModel(
        name: 'Test travels',
        expenses: {
          '2024-01': {
            'Fuel Allowance': 4000.0,
            'Utility Bills': 3000.0,
          },
          '2024-02': {'Dummy Expense': 500.0},
          '2024-03': {'Dummy Expense': 500.0},
          '2024-04': {'Dummy Expense': 500.0},
          '2024-05': {'Dummy Expense': 500.0},
          '2024-06': {'Dummy Expense': 500.0},
          '2024-07': {'Dummy Expense': 500.0},
          '2024-08': {'Dummy Expense': 500.0},
          '2024-09': {'Dummy Expense': 500.0},
          '2024-10': {'Dummy Expense': 500.0},
          '2024-11': {'Dummy Expense': 500.0},
          '2024-12': {'Dummy Expense': 500.0},
        },
      ),
      TotalMonthlyExpensesModel(
        name: 'AGENT1 (Main Branch)',
        expenses: {
          '2024-01': {'Dummy Expense': 500.0},
          '2024-02': {
            'Fuel Allowance': 8000.0,
            'Dummy Expense': 500.0,
          },
          '2024-03': {'Dummy Expense': 500.0},
          '2024-04': {'Dummy Expense': 500.0},
          '2024-05': {'Dummy Expense': 500.0},
          '2024-06': {'Dummy Expense': 500.0},
          '2024-07': {
            'HUSSAIN ALI ISB EMP': 45000.0,
            'Dummy Expense': 500.0,
          },
          '2024-08': {'Dummy Expense': 500.0},
          '2024-09': {'Dummy Expense': 500.0},
          '2024-10': {
            'Discount': 2269970.0,
            'Dummy Expense': 500.0,
          },
          '2024-11': {'Dummy Expense': 500.0},
          '2024-12': {'Dummy Expense': 500.0},
        },
      ),
    ];
  }



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

  double calculateCompanyTotalForMonth(TotalMonthlyExpensesModel company, String monthKey) {
    double total = 0.0;
    final monthExpenses = company.expenses[monthKey] ?? {};
    monthExpenses.forEach((_, value) {
      total += value;
    });
    return total;
  }

  double calculateTotalExpenses() {
    return companies.fold(0.0, (sum, company) => sum + company.getTotalExpenses());
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }
}