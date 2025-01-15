import 'package:evoucher/views/side_bar/incomes_report/widget/month_card_widget.dart';
import 'package:evoucher/views/side_bar/incomes_report/widget/total_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/income_controller.dart';

class IncomesComparisonReport extends GetView<IncomesReportController> {
  const IncomesComparisonReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Incomes Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 8),
      body: Column(
        children: [
          _buildDateSelectors(),
          Expanded(
            child: Obx(() {
              final months = controller.getMonthsBetween();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: months.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildTotalSummaryCard();
                  }
                  return MonthCardWidget(month: months[index - 1]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() => DateSelector2(
                      label: 'From Month',
                      fontSize: 12,
                      initialDate: controller.fromDate.value,
                      selectMonthOnly: true,
                      onDateChanged: controller.updateFromDate,
                    )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => DateSelector2(
                      label: 'To Month',
                      fontSize: 12,
                      initialDate: controller.toDate.value,
                      selectMonthOnly: true,
                      onDateChanged: controller.updateToDate,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.errorMessage.isNotEmpty
                    ? controller.errorMessage.value
                    : 'From ${DateFormat('MMM yyyy').format(controller.fromDate.value)} To ${DateFormat('MMM yyyy').format(controller.toDate.value)}',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTotalSummaryCard() {
    return Obx(() {
      final totals = controller.getTotalSummary();
      if (totals.isEmpty) {
        return const Center(child: Text('No data available.'));
      }

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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio:
                    0.9, // Changed from 1.2 to 1.0 for more height
                crossAxisSpacing: 12, // Increased spacing
                mainAxisSpacing: 12,
              ),
              itemCount: totals.length,
              itemBuilder: (context, index) {
                final entry = totals.entries.elementAt(index);
                return TotalItemWidget(
                  label: entry.key,
                  amount: entry.value,
                  icon: _getIconForCategory(entry.key),
                  total: entry.value,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
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
      default:
        return Icons.device_unknown;
    }
  }
}
