class TotalMonthlyExpensesModel {
  final String name;
  final Map<String, Map<String, double>> expenses;

  TotalMonthlyExpensesModel({
    required this.name,
    required this.expenses,
  });

  double getTotalExpenses() {
    double total = 0.0;
    expenses.forEach((month, expenseMap) {
      expenseMap.forEach((_, value) {
        total += value;
      });
    });
    return total;
  }

  Map<String, double> getExpensesForMonth(String monthKey) {
    return expenses[monthKey] ?? {};
  }
}