import 'package:evoucher_new/common_widget/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../service/api_service.dart';
import '../models/expense_item_modal.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class ExpenseReportController extends GetxController {
  final fromDate = DateTime(2024, 1).obs;
  final toDate = DateTime(2024, 12).obs;
  final expenseItems = <ExpenseItemModel>[].obs;
  final isLoading = true.obs;
  final ApiService apiService = ApiService();
  final monthlyTotals = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    fromDate.value = DateTime(now.year, now.month, 1);
    toDate.value = DateTime(now.year, now.month, 1);
    print('🚀 ExpenseReportController initialized');
    print('Initial From Date: ${fromDate.value}');
    print('Initial To Date: ${toDate.value}');
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    try {
      isLoading.value = true;

      // Format dates for API request
      String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate.value);
      String toDateStr = DateFormat('yyyy-MM-dd').format(toDate.value);

      print('\n🔍 API Request Details:');
      print('Endpoint: expensesReport');
      print('From Date: $fromDateStr');
      print('To Date: $toDateStr');

      // Prepare the request body
      final requestBody = {
        "fromDate": fromDateStr,
        "toDate": toDateStr,
        // Add any additional parameters if required by your API
      };

      print('📝 Request Body:');
      print(requestBody);
      print('\n' + '=' * 60 + '\n');

      // Make API call using postRequest
      final response = await apiService.postRequest(
        endpoint: 'expensesReport',
        body: requestBody,
      );

      print('📦 COMPLETE API RESPONSE:');
      print('Response Type: ${response.runtimeType}');
      print('Response: $response');
      print('\n' + '=' * 60 + '\n');

      if (response['status'] == 'success') {
        print('✅ API Status: SUCCESS');

        // Log data section
        print('📊 Response Data Section:');
        print('Data: ${response['data']}');
        print('\n' + '-' * 40 + '\n');

        // Parse expense accounts
        final expenseAccounts = response['data']['expense_accounts'] as List;
        print('💰 Expense Accounts (Raw):');
        print('Count: ${expenseAccounts.length}');
        for (int i = 0; i < expenseAccounts.length; i++) {
          print('Account $i: ${expenseAccounts[i]}');
        }
        print('\n' + '-' * 30 + '\n');

        expenseItems.value = expenseAccounts.map((account) {
          print('🔄 Processing Account: ${account['account_name']}');
          print('Account Data: $account');

          final monthlyAmounts = (account['monthly_amounts'] as List).first;
          print('Monthly Amounts: $monthlyAmounts');

          final expenseItem = ExpenseItemModel(
            name: account['account_name'],
            amount: (monthlyAmounts['amount']).toDouble(),
            total: account['total'].toDouble(),
          );

          print('✨ Created ExpenseItem:');
          print('  Name: ${expenseItem.name}');
          print('  Amount: ${expenseItem.amount}');
          print('  Total: ${expenseItem.total}');
          print('');

          return expenseItem;
        }).toList();

        print('📈 Final Expense Items:');
        print('Total Items: ${expenseItems.length}');
        for (var item in expenseItems) {
          print('- ${item.name}: ${item.amount} (Total: ${item.total})');
        }
        print('\n' + '-' * 30 + '\n');

        // Parse monthly totals
        final monthlyTotalsRaw = response['data']['monthly_totals'] as List;
        print('📅 Monthly Totals (Raw):');
        print('Count: ${monthlyTotalsRaw.length}');
        for (int i = 0; i < monthlyTotalsRaw.length; i++) {
          print('Month $i: ${monthlyTotalsRaw[i]}');
        }

        monthlyTotals.value = monthlyTotalsRaw
            .map((e) => {
                  'month': e['month'],
                  'total': e['total'],
                  'formatted_total': e['formatted_total']
                })
            .toList();

        print('📊 Processed Monthly Totals:');
        for (var total in monthlyTotals) {
          print(
              '- Month: ${total['month']}, Total: ${total['total']}, Formatted: ${total['formatted_total']}');
        }

        print('\n🎯 SUMMARY:');
        print('✓ Expense Items: ${expenseItems.length}');
        print('✓ Monthly Totals: ${monthlyTotals.length}');
        print('✓ Data loaded successfully');
      } else {
        print('❌ API Status: ${response['status']}');
        print('Message: ${response['message'] ?? 'No message provided'}');
        print('Full Response: $response');
      }
    } catch (e, stackTrace) {
      print('\n💥 EXCEPTION OCCURRED:');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace:');
      print(stackTrace);
      print('\n' + '=' * 60 + '\n');

      // Also use developer.log for better debugging
      developer.log(
        'Failed to fetch expense data',
        error: e,
        stackTrace: stackTrace,
        name: 'ExpenseReportController',
      );

      CustomSnackBar(message: "Failed to load expense data. Please try again.")
          .show();
    } finally {
      isLoading.value = false;
      print('🔄 Loading finished - isLoading: ${isLoading.value}');
      print('\n' + '=' * 60 + '\n');
    }
  }

  void updateFromDate(DateTime date) {
    print('📅 Updating From Date: ${fromDate.value} → $date');
    fromDate.value = date;
    fetchExpenseData();
  }

  void updateToDate(DateTime date) {
    print('📅 Updating To Date: ${toDate.value} → $date');
    toDate.value = date;
    fetchExpenseData();
  }

  List<DateTime> getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate.value;
    while (current.isBefore(toDate.value) ||
        current.month == toDate.value.month &&
            current.year == toDate.value.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    print(
        '📆 Months between ${fromDate.value} and ${toDate.value}: ${months.length}');
    return months;
  }

  String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
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
