import 'package:flutter/material.dart';

class ExpenseItemModel {
  final String name;
  final double amount;
  final IconData icon;

  ExpenseItemModel({
    required this.name,
    required this.amount,
    this.icon = Icons.monetization_on
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseItemModel(
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