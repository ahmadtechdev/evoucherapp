import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../models/total_monthly_profit_loss_model.dart';


class TotalMonthlyProfitLossController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final companies = <TotalMonthlyProfitLossModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    companies.value = [
      TotalMonthlyProfitLossModel(
        name: 'AGENT1 (Main Branch)',
        expenses: {'2024-11': 100.0, '2024-12': -280.0},
        incomes: {'2024-11': 15.0, '2024-12': 150.0},
        profitLoss: {'2024-11': 179.0, '2024-12': 150.0},
      ),
      TotalMonthlyProfitLossModel(
        name: 'Test travels',
        expenses: {'2024-11': 340.0, '2024-12': 120.0},
        incomes: {'2024-11': -21220.0, '2024-12': 2440.0},
        profitLoss: {'2024-11': 2550.0, '2024-12': 240.0},
      ),
      TotalMonthlyProfitLossModel(
        name: 'travel High',
        expenses: {'2024-11': 3530.0, '2024-12': -210.0},
        incomes: {'2024-11': 340.0, '2024-12': 120.0},
        profitLoss: {'2024-11': -530.0, '2024-12': 350.0},
      ),
    ];
  }

  List<DateTime> getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate.value;
    while (current.isBefore(toDate.value) ||
        current.month == toDate.value.month && current.year == toDate.value.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    return months;
  }

  double calculateTotalProfit() {
    return companies.fold(0.0, (sum, company) => sum + company.getTotalProfit());
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }

  String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  Color getColorForProfitLoss(double value) {
    if (value > 0) return TColor.secondary;
    if (value < 0) return TColor.third;
    return Colors.black;
  }

  double calculateMonthTotal(DateTime month) {
    final monthKey = getMonthKey(month);
    return companies.fold(0.0, (sum, company) =>
    sum + (company.profitLoss[monthKey] ?? 0.0));
  }
}