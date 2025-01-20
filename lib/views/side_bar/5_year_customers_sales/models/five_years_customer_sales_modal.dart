class FiveYearCustomersSalesModel {
  final String accountId;
  final String name;
  final Map<String, double> yearlySales;
  final double total;

  FiveYearCustomersSalesModel({
    required this.accountId,
    required this.name,
    required this.yearlySales,
    required this.total,
  });

  factory FiveYearCustomersSalesModel.fromJson(Map<String, dynamic> json) {
    // Convert yearly_sales array to map
    final yearlySalesMap = <String, double>{};
    final yearlySalesArray = json['yearly_sales'] as List;

    for (var yearData in yearlySalesArray) {
      yearlySalesMap[yearData['year'].toString()] =
          double.parse(yearData['total_sales'].toString());
    }

    return FiveYearCustomersSalesModel(
      accountId: json['account_id'],
      name: json['account_name'],
      yearlySales: yearlySalesMap,
      total: double.parse(json['total_sale'].toString()),
    );
  }
}
