// lib/controllers/daily_sales_report_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';
import '../models/daily_sales_report_model.dart';

class DailySalesReportController extends GetxController {
  var salesData = <SaleEntry>[].obs;
  final ApiService _apiService = ApiService();

  var selectedDateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  ).obs;

  final DateFormat displayFormat = DateFormat('EEE, dd MMM yyyy');
  final DateFormat apiFormat = DateFormat('yyyy-MM-dd');

  Future<void> fetchDailySalesReport(DateTimeRange dateRange) async {
    try {
      final response = await _apiService.postRequest(
        endpoint: 'allSalesReport',
        body: {
          "fromDate": apiFormat.format(dateRange.start),
          "toDate": apiFormat.format(dateRange.end),
        },
      );

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> records = response['data']['daily_records'] ?? [];
        salesData.value =
            records.map((record) => SaleEntry.fromJson(record)).toList();
      } else {
        throw Exception('Failed to load sales report');
      }
    } catch (e) {
      rethrow;
    }
  }

  String formatDisplayDate(DateTime date) {
    return displayFormat.format(date);
  }

  void updateDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
  }
}
