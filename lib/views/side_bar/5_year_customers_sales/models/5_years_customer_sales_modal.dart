// lib/models/sale.dart

class FiveYearCustomersSalesModel {
  final String name;
  final Map<String, double> yearlySales;
  final double total;

  FiveYearCustomersSalesModel({required this.name, required this.yearlySales})
      : total = yearlySales.values.reduce((a, b) => a + b);
}