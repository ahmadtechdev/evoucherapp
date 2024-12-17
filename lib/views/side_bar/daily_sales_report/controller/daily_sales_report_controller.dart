// lib/controllers/daily_sales_report_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/daily_sales_report_model.dart';

class DailySalesReportController extends GetxController {
  var salesData = <SaleEntry>[].obs;
  var selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 15)),
    end: DateTime.now(),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadSampleData();
  }

  void loadSampleData() {
    salesData.addAll([
      SaleEntry.fromMap({
        "date": "2024-12-01",
        "summary": {"vNo": "V123", "totalP": 1200, "totalS": 24000, "pL": 2000},
        "details": {
          "vDate": "2024-12-01",
          "cAccount": "Account 1",
          "sAccount": "Account 2",
          "paxName": "John Doe"
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-12-03",
        "summary": {"vNo": "V124", "totalP": 8000, "totalS": 16000, "pL": 1500},
        "details": {
          "vDate": "2024-12-03",
          "cAccount": "Account 3",
          "sAccount": "Account 4",
          "paxName": "Alice"
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-11-01",
        "summary": {"vNo": "V201", "totalP": 1500, "totalS": 2000, "pL": 500},
        "details": {
          "vDate": "2024-06-01",
          "cAccount": "Account A",
          "sAccount": "Account B",
          "paxName": "John Smith",
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-11-04",
        "summary": {"vNo": "V202", "totalP": 3000, "totalS": 2500, "pL": -500},
        "details": {
          "vDate": "2024-06-04",
          "cAccount": "Account C",
          "sAccount": "Account D",
          "paxName": "Alice Johnson",
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-11-08",
        "summary": {"vNo": "V203", "totalP": 2500, "totalS": 3500, "pL": 1000},
        "details": {
          "vDate": "2024-06-08",
          "cAccount": "Account E",
          "sAccount": "Account F",
          "paxName": "Bob Brown",
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-10-02",
        "summary": {"vNo": "V204", "totalP": 4000, "totalS": 5000, "pL": 1000},
        "details": {
          "vDate": "2024-07-02",
          "cAccount": "Account G",
          "sAccount": "Account H",
          "paxName": "Chris Evans",
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-10-10",
        "summary": {"vNo": "V205", "totalP": 2000, "totalS": 1500, "pL": -500},
        "details": {
          "vDate": "2024-07-10",
          "cAccount": "Account I",
          "sAccount": "Account J",
          "paxName": "Diana Prince",
        },
      }),
      SaleEntry.fromMap({
        "date": "2024-10-15",
        "summary": {"vNo": "V206", "totalP": 5000, "totalS": 7000, "pL": 2000},
        "details": {
          "vDate": "2024-07-15",
          "cAccount": "Account K",
          "sAccount": "Account L",
          "paxName": "Edward Stone",
        },
      }),
      // Add more entries as needed...
    ]);
  }


  List<SaleEntry> filterData() {
    return salesData.where((entry) {
      final entryDate = DateTime.parse(entry.date);
      return entryDate.isAfter(selectedDateRange.value.start.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(selectedDateRange.value.end.add(const Duration(days: 1)));
    }).toList();
  }

  int calculateTotal(String key) {
    return salesData.fold<int>(
      0,
          (sum, entry) => sum + (entry.summary[key] as int),
    );
  }

  void updateDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
  }
}