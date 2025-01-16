class TotalMonthlyExpensesModel {
  final String name;
  final Map<String, Map<String, double>> expenses;
  final double total;

  TotalMonthlyExpensesModel({
    required this.name,
    required this.expenses,
    required this.total,
  });

  factory TotalMonthlyExpensesModel.fromApiData(String name, Map<String, dynamic> data) {
    final monthlyDetails = (data['monthly_details'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        key,
        {'expense': (value as num).toDouble()},
      ),
    );

    return TotalMonthlyExpensesModel(
      name: name,
      expenses: monthlyDetails,
      total: (data['total'] as num).toDouble(),
    );
  }

  double getTotalExpenses() {
    return total;
  }

  Map<String, double> getExpensesForMonth(String monthKey) {
    return expenses[monthKey] ?? {};
  }
}