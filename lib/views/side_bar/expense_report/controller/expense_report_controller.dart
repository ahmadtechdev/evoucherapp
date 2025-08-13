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
  
  // Store raw expense accounts data for monthly calculations
  final rawExpenseAccounts = <Map<String, dynamic>>[].obs;

  // Flag to control debug logging
  static const bool _debugMode = true;

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    fromDate.value = DateTime(now.year, now.month, 1);
    toDate.value = DateTime(now.year, now.month, 1);
    
    if (_debugMode) {
      print('ExpenseReportController initialized');
      print('Date range: ${fromDate.value} to ${toDate.value}');
    }
    
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    try {
      isLoading.value = true;

      // Format dates for API request
      String fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate.value);
      String toDateStr = DateFormat('yyyy-MM-dd').format(toDate.value);

      // Prepare the request body
      final requestBody = {
        "fromDate": fromDateStr,
        "toDate": toDateStr,
      };

      if (_debugMode) {
        print('Fetching expense data: $fromDateStr to $toDateStr');
      }

      // Make API call
      final response = await apiService.postRequest(
        endpoint: 'expensesReport',
        body: requestBody,
      );

      if (response['status'] == 'success') {
        if (_debugMode) {
          print('✅ API Status: SUCCESS');
        }

        // Parse expense accounts
        final expenseAccounts = response['data']['expense_accounts'] as List;
        
        // Store raw data for monthly calculations
        rawExpenseAccounts.value = List<Map<String, dynamic>>.from(expenseAccounts);
        
        // Create expense items
        expenseItems.value = expenseAccounts.map((account) {
          final monthlyAmounts = (account['monthly_amounts'] as List);
          
          return ExpenseItemModel(
            name: account['account_name'],
            amount: 0, // Will be calculated dynamically per month
            total: account['total'].toDouble(),
            monthlyAmounts: monthlyAmounts,
          );
        }).toList();

        // Parse monthly totals - FIXED: Store with proper key matching
        if (response['data']['monthly_totals'] != null) {
          final monthlyTotalsRaw = response['data']['monthly_totals'] as List;
          
          monthlyTotals.value = monthlyTotalsRaw
              .map((e) => {
                    'month': e['month'].toString().trim(), // Ensure clean string
                    'total': e['total'],
                    'formatted_total': e['formatted_total']
                  })
              .toList();
              
          // Debug: Print all monthly totals
          if (_debugMode) {
            print('\n🎯 PARSED MONTHLY TOTALS:');
            for (var total in monthlyTotals) {
              print('Key: "${total['month']}" -> Total: ${total['total']}');
            }
          }
        }

        if (_debugMode) {
          print('🎯 FINAL SUMMARY:');
          print('Expense Items Count: ${expenseItems.length}');
          print('Monthly Totals Count: ${monthlyTotals.length}');
          
          // Call debug method to print all data
          debugPrintAllData();
        }
        
      } else {
        if (_debugMode) {
          print('❌ API Error: ${response['status']} - ${response['message']}');
        }
        CustomSnackBar(
          message: response['message'] ?? "Failed to load expense data."
        ).show();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch expense data',
        error: e,
        stackTrace: stackTrace,
        name: 'ExpenseReportController',
      );

      if (_debugMode) {
        print('💥 Exception: $e');
      }

      CustomSnackBar(message: "Failed to load expense data. Please try again.")
          .show();
    } finally {
      isLoading.value = false;
    }
  }

  // FIXED: Get monthly amount for specific expense account and month
  double getMonthlyAmountForAccount(String accountName, String monthKey) {
    if (_debugMode) {
      print('🔍 Looking for: Account="$accountName", Month="$monthKey"');
    }
    
    final account = rawExpenseAccounts.firstWhere(
      (acc) => acc['account_name'] == accountName,
      orElse: () => {},
    );
    
    if (account.isEmpty) {
      if (_debugMode) {
        print('❌ Account not found: $accountName');
      }
      return 0.0;
    }
    
    final monthlyAmounts = account['monthly_amounts'] as List? ?? [];
    
    // Clean the monthKey for comparison
    String cleanMonthKey = monthKey.trim();
    
    // Find exact match first
    var monthData = monthlyAmounts.firstWhere(
      (month) => month['month'].toString().trim() == cleanMonthKey,
      orElse: () => null,
    );
    
    if (monthData == null) {
      if (_debugMode) {
        print('❌ Month not found: $cleanMonthKey');
        print('Available months: ${monthlyAmounts.map((m) => m['month']).toList()}');
      }
      return 0.0;
    }
    
    double amount = (monthData['amount'] ?? 0).toDouble();
    
    if (_debugMode) {
      print('✅ Found amount: $amount for $accountName in $cleanMonthKey');
    }
    
    return amount;
  }

  // FIXED: Get monthly total for specific month with better matching
  double getMonthlyTotal(String monthKey) {
    String cleanMonthKey = monthKey.trim();
    
    if (_debugMode) {
      print('🔍 Looking for monthly total for: "$cleanMonthKey"');
      print('Available totals: ${monthlyTotals.map((t) => t['month']).toList()}');
    }
    
    final monthData = monthlyTotals.firstWhere(
      (total) => total['month'].toString().trim() == cleanMonthKey,
      orElse: () => {'total': 0},
    );
    
    double total = (monthData['total'] ?? 0).toDouble();
    
    if (_debugMode) {
      print('✅ Monthly total for $cleanMonthKey: $total');
    }
    
    return total;
  }

  void updateFromDate(DateTime date) {
    if (_debugMode) {
      print('📅 From date updated: $date');
    }
    fromDate.value = date;
    fetchExpenseData();
  }

  void updateToDate(DateTime date) {
    if (_debugMode) {
      print('📅 To date updated: $date');
    }
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

  // Debug method to print all data for troubleshooting
  void debugPrintAllData() {
    print('\n🔥 =========================== DEBUG ALL DATA ===========================');
    
    // Debug raw expense accounts
    print('\n📊 RAW EXPENSE ACCOUNTS:');
    for (int i = 0; i < rawExpenseAccounts.length; i++) {
      var account = rawExpenseAccounts[i];
      print('Account ${i + 1}: ${account['account_name']}');
      var monthlyAmounts = account['monthly_amounts'] as List;
      for (var monthData in monthlyAmounts) {
        print('  - Month: "${monthData['month']}" = ${monthData['amount']}');
      }
    }
    
    // Debug monthly totals
    print('\n💰 MONTHLY TOTALS:');
    for (int i = 0; i < monthlyTotals.length; i++) {
      var total = monthlyTotals[i];
      print('Total ${i + 1}: Month="${total['month']}" = ${total['total']}');
    }
    
    // Test specific lookups
    print('\n🧪 TESTING LOOKUPS:');
    
    // Test for July 2025
    print('\nTesting July 2025:');
    double julyTotal = getMonthlyTotal('Jul 2025');
    print('July Total: $julyTotal');
    
    // Test Mobile Allowance for both months
    double julyMobile = getMonthlyAmountForAccount('Mobile Allowance', 'Jul 2025');
    double augMobile = getMonthlyAmountForAccount('Mobile Allowance', 'Aug 2025');
    print('Mobile Allowance - July: $julyMobile, August: $augMobile');
    
    // Test for August 2025
    print('\nTesting August 2025:');
    double augTotal = getMonthlyTotal('Aug 2025');
    print('August Total: $augTotal');
    
    print('\n🔥 ========================= END DEBUG DATA =========================\n');
  }
}