// Update in MonthCardWidget

import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/views/side_bar/incomes_report/controller/income_controller.dart';
import 'package:evoucher/views/side_bar/incomes_report/widget/income_card_widget.dart';
import 'package:evoucher/views/side_bar/incomes_report/widget/total_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonthCardWidget extends GetView<IncomesReportController> {
  final DateTime month;

  const MonthCardWidget({
    super.key,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final monthStr = DateFormat('MMM yyyy').format(month);
    final monthData = controller.getIncomeDataForMonth(monthStr);
    final monthTotal = controller.getTotalForMonth(monthStr);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthStr,
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.calendar_month, color: TColor.primary),
              ],
            ),
          ),
          ...buildIncomeItems(monthData),
          const Divider(thickness: 2, height: 1),
          IncomeCardWidget(
            title: 'Total',
            amount: monthTotal,
            icon: Icons.summarize,
            color: TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  List<Widget> buildIncomeItems(Map<String, dynamic> monthData) {
    final incomeTypes = {
      'Package Income': Icons.receipt,
      'Ticket Income': Icons.monetization_on,
      'Hotel Incomes': Icons.hotel,
      'Visa Incomes': Icons.credit_card,
      'Other Incomes': Icons.attach_money,
      'Transport Income': Icons.directions_car,
      'Fine Penalties': Icons.close,
      'Other Penalties': Icons.devices_other,
    };

    return incomeTypes.entries.map((entry) {
      final data =
          monthData[entry.key] ?? {'amount': '0.00', 'is_negative': false};
      return IncomeCardWidget(
        title: entry.key,
        amount: data['amount'],
        icon: entry.value,
        color: TColor.primary,
      );
    }).toList();
  }
}

// Update in IncomesComparisonReport class
Widget _buildTotalSummaryCard() {
  return Obx(() {
    final totals = IncomesReportController().getTotalSummary();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Incomes Summary',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: totals.entries.map((entry) {
              return Expanded(
                child: TotalItemWidget(
                  label: entry.key,
                  total: entry.value,
                  icon: getIconForIncomeType(entry.key),
                  amount: '',
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  });
}

IconData getIconForIncomeType(String type) {
  switch (type) {
    case 'Package Income':
      return Icons.receipt;
    case 'Ticket Income':
      return Icons.monetization_on;
    case 'Hotel Incomes':
      return Icons.hotel;
    case 'Visa Incomes':
      return Icons.credit_card;
    case 'Other Incomes':
      return Icons.attach_money;
    case 'Transport Income':
      return Icons.directions_car;
    case 'Fine Penalties':
      return Icons.close;
    case 'Other Penalties':
      return Icons.devices_other;
    default:
      return Icons.attach_money;
  }
}
