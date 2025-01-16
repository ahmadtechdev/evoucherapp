import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../service/api_service.dart';
import '../models/five_years_customer_sales_modal.dart';

class FiveYearCustomersSalesController extends GetxController {
  final apiService = Get.put(ApiService());
  final selectedYear = Rxn<String>();
  final searchQuery = ''.obs;
  final RxList<String> years = <String>[].obs;
  final RxList<FiveYearCustomersSalesModel> salesData = <FiveYearCustomersSalesModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiveYearSales();
  }

  Future<void> fetchFiveYearSales() async {
    try {
      isLoading.value = true;

      final response = await apiService.postRequest(
        endpoint: 'fiveYearCustomerSales',
        body: {
          'year': selectedYear.value ?? '',
        },
      );

      if (response['status'] == 'success') {
        // Update years list from API response
        if (response['year_range'] != null) {
          final yearRange = (response['year_range'] as List).cast<String>();
          years.value = yearRange;
        }

        // Parse sales data
        final List<dynamic> data = response['data'] as List;
        final List<FiveYearCustomersSalesModel> parsedData = data
            .map((item) => FiveYearCustomersSalesModel.fromJson(item))
            .toList();

        salesData.value = parsedData;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch five year sales  ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<FiveYearCustomersSalesModel> get filteredData {
    var filtered = salesData
        .where((sale) =>
        sale.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();

    if (selectedYear.value != null) {
      filtered.sort((a, b) {
        double valueA = a.yearlySales[selectedYear.value] ?? 0.0;
        double valueB = b.yearlySales[selectedYear.value] ?? 0.0;

        if (valueA == 0 && valueB == 0) return 0;
        if (valueA == 0) return 1;
        if (valueB == 0) return -1;
        return valueB.compareTo(valueA); // Sort in descending order
      });
    }

    return filtered;
  }
}
