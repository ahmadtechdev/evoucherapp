// lib/controllers/sales_controller.dart

import 'package:get/get.dart';

import '../models/five_years_customer_sales_modal.dart';

class FiveYearCustomersSalesController extends GetxController {
  var selectedYear = Rxn<String>();
  var searchQuery = ''.obs;
  final List<String> years = ["2020", "2021", "2022", "2023", "2024"];

  final List<FiveYearCustomersSalesModel> salesData = [
    FiveYearCustomersSalesModel(name: "ALI AMEEN", yearlySales: {"2020": 0.0, "2021": 0.0, "2022": 0.0, "2023": 775000.00, "2024": 135000.00}),
    FiveYearCustomersSalesModel(name: "MOHSIN ALI", yearlySales: {"2020": 0.0, "2021": 0.0, "2022": 301766.00, "2023": 0.0, "2024": 385000.00}),
    FiveYearCustomersSalesModel(name: "AHMED KHAN", yearlySales: {"2020": 100000.00, "2021": 200000.00, "2022": 150000.00, "2023": 300000.00, "2024": 400000.00}),
    FiveYearCustomersSalesModel(name: "USMAN SAEED", yearlySales: {"2020": 50000.00, "2021": 0.0, "2022": 100000.00, "2023": 200000.00, "2024": 250000.00}),
    FiveYearCustomersSalesModel(name: "KASHIF ALI", yearlySales: {"2020": 0.0, "2021": 75000.00, "2022": 125000.00, "2023": 175000.00, "2024": 250000.00}),
    FiveYearCustomersSalesModel(name: "FAHAD RAZA", yearlySales: {"2020": 25000.00, "2021": 50000.00, "2022": 75000.00, "2023": 100000.00, "2024": 150000.00}),
    FiveYearCustomersSalesModel(name: "ASIF IQBAL", yearlySales: {"2020": 0.0, "2021": 0.0, "2022": 200000.00, "2023": 300000.00, "2024": 350000.00}),
    FiveYearCustomersSalesModel(name: "SAQIB JAVED", yearlySales: {"2020": 100000.00, "2021": 150000.00, "2022": 0.0, "2023": 200000.00, "2024": 300000.00}),
    FiveYearCustomersSalesModel(name: "TANVIR HUSSAIN", yearlySales: {"2020": 0.0, "2021": 50000.00, "2022": 100000.00, "2023": 150000.00, "2024": 250000.00}),
    FiveYearCustomersSalesModel(name: "HASSAN SHAH", yearlySales: {"2020": 75000.00, "2021": 100000.00, "2022": 125000.00, "2023": 150000.00, "2024": 175000.00}),
  ];

  List<FiveYearCustomersSalesModel> get filteredData {
    var filtered = salesData
        .where((sale) => sale.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();

    // Only sort if a year is selected
    if (selectedYear.value != null) {
      filtered.sort((a, b) {
        double valueA = a.yearlySales[selectedYear.value] ?? 0.0;
        double valueB = b.yearlySales[selectedYear.value] ?? 0.0;

        if ((valueA == 0 && valueB == 0) || (valueA != 0 && valueB != 0)) {
          return 0;
        }
        return valueA == 0 ? -1 : 1;
      });
    }

    return filtered;
  }
}