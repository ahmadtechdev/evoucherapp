import 'package:flutter/material.dart';

class ExpenseItem {
  final String name;
  final double amount;
  final IconData icon;

  ExpenseItem({
    required this.name,
    required this.amount,
    this.icon = Icons.monetization_on
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      icon: json['icon'] ?? Icons.monetization_on,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}