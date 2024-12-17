class TotalMonthlyProfitLossModel {
  final String name;
  final Map<String, double> expenses;
  final Map<String, double> incomes;
  final Map<String, double> profitLoss;

  TotalMonthlyProfitLossModel({
    required this.name,
    required this.expenses,
    required this.incomes,
    required this.profitLoss,
  });

  double getTotalProfit() {
    return profitLoss.values.fold(0, (sum, value) => sum + value);
  }
}