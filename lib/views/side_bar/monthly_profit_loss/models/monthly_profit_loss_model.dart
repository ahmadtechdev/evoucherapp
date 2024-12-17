class MonthlyProfitLossModel {
  final String name;
  final Map<String, Map<String, double>> expenses;
  final Map<String, Map<String, double>> incomes;

  MonthlyProfitLossModel({
    required this.name,
    required this.expenses,
    required this.incomes,
  });

  double getTotalExpensesForMonth(String monthKey) {
    double total = 0.0;
    final monthExpenses = expenses[monthKey] ?? {};
    monthExpenses.forEach((_, value) {
      total += value;
    });
    return total;
  }

  double getTotalIncomesForMonth(String monthKey) {
    double total = 0.0;
    final monthIncomes = incomes[monthKey] ?? {};
    monthIncomes.forEach((_, value) {
      total += value;
    });
    return total;
  }

  double getProfitLossForMonth(String monthKey) {
    return getTotalIncomesForMonth(monthKey) - getTotalExpensesForMonth(monthKey);
  }

  Map<String, double> getExpensesForMonth(String monthKey) {
    return expenses[monthKey] ?? {};
  }

  Map<String, double> getIncomesForMonth(String monthKey) {
    return incomes[monthKey] ?? {};
  }
}