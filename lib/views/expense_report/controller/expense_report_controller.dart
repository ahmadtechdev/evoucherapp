import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'expense_item_modal.dart';



class ExpenseReportController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 11).obs;
  final expenseItems = <ExpenseItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    expenseItems.value = [
      ExpenseItem(name: 'Staff Salaries', amount: 0.00),
      ExpenseItem(name: 'Bonus Allowance', amount: 0.00),
      ExpenseItem(name: 'Fuel Allowance', amount: 8000.00),
      ExpenseItem(name: 'Incentive Allowance', amount: 0.00),
      ExpenseItem(name: 'Mobile Allowance', amount: 0.00),
      ExpenseItem(name: 'Other Allowance', amount: 0.00),
      ExpenseItem(name: 'Staff Salary Pzz', amount: 0.00),
      ExpenseItem(name: 'Discount', amount: 0.00),
      ExpenseItem(name: 'Hussain Ali ISB EMP', amount: 0.00),
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

  double calculateTotalExpenses() {
    return expenseItems.fold(0.0, (sum, item) => sum + item.amount);
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }

  String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  Color getColorForIndex(int index) {
    final colors = [
      Get.theme.primaryColor,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.deepPurple,
      Colors.orange
    ];
    return colors[index % colors.length];
  }
}