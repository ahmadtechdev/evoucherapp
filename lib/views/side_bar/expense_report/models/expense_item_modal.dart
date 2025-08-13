import 'package:flutter/material.dart';

class ExpenseItemModel {
  final String name;
  final double amount;
  final IconData icon;
  final double total;
  final List<dynamic>? monthlyAmounts; // Add this field

  ExpenseItemModel({
    required this.name,
    required this.amount,
    required this.total,
    this.monthlyAmounts, // Add this parameter
    this.icon = Icons.monetization_on,
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseItemModel(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      monthlyAmounts: json['monthlyAmounts'],
      icon: json['icon'] ?? Icons.monetization_on,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'total': total,
      'monthlyAmounts': monthlyAmounts,
    };
  }
  
  // Helper method to get amount for specific month
  double getAmountForMonth(String monthKey) {
    if (monthlyAmounts == null) return 0.0;
    
    final monthData = monthlyAmounts!.firstWhere(
      (month) => month['month'] == monthKey,
      orElse: () => {'amount': 0},
    );
    
    return (monthData['amount'] ?? 0).toDouble();
  }
  
  // Get all monthly amounts as a map
  Map<String, double> getAllMonthlyAmounts() {
    if (monthlyAmounts == null) return {};
    
    Map<String, double> amounts = {};
    for (var monthData in monthlyAmounts!) {
      amounts[monthData['month']] = (monthData['amount'] ?? 0).toDouble();
    }
    return amounts;
  }
}