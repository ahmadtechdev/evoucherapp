// lib/views/widgets/summary_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../common/color_extension.dart';
import '../controller/daily_sales_report_controller.dart';
import '../models/daily_sales_report_model.dart';

class SummaryCard extends StatelessWidget {
  final List<SaleEntry> data;
  final DailySalesReportController controller = Get.find();

  SummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final totalPurchase = controller.calculateTotal('totalP');
    final totalSales = controller.calculateTotal('totalS');
    final totalProfit = controller.calculateTotal('pL');

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TColor.primary.withOpacity(0.2), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Entries: ${data.length}',
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                // Summary Items
                // (Same as before)
              ],
            ),
          ],
        ));
  }
}

class SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const SummaryItem(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: TColor.primary),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: TColor.primaryText.withOpacity(0.7), fontSize: 14)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
