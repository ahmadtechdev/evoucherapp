import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';
import 'controller/monthly_profit_loss_controller.dart';

class MonthlyProfitLoss extends StatelessWidget {
  MonthlyProfitLoss({super.key});

  final MonthlyProfitLossController controller = Get.put(MonthlyProfitLossController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Monthly Profit Loss'),
      ),
      drawer: const CustomDrawer(currentIndex: 12),
      body: Column(
        children: [
          _buildDateSelectionHeader(),
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionHeader('Expenses', TColor.third),
                  ...controller.getMonthsBetween().map((month) =>
                      _buildExpenseCard(month)),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Incomes', TColor.secondary),
                  ...controller.getMonthsBetween().map((month) =>
                      _buildIncomeCard(month)),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Profit/Loss Comparison', TColor.primary),
                  ...controller.getMonthsBetween().map((month) =>
                      _buildProfitLossCard(month)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExpenseCard(DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final monthExpenses = controller.data.value.getExpensesForMonth(monthKey);

    if (monthExpenses.isEmpty) {
      return Container();
    }

    return _buildMonthlyCard(
      month,
      monthExpenses,
      TColor.third,
      controller.data.value.getTotalExpensesForMonth(monthKey),
    );
  }

  Widget _buildIncomeCard(DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final monthIncomes = controller.data.value.getIncomesForMonth(monthKey);

    if (monthIncomes.isEmpty) {
      return Container();
    }

    return _buildMonthlyCard(
      month,
      monthIncomes,
      TColor.secondary,
      controller.data.value.getTotalIncomesForMonth(monthKey),
    );
  }

  Widget _buildProfitLossCard(DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final expenses = controller.data.value.getTotalExpensesForMonth(monthKey);
    final incomes = controller.data.value.getTotalIncomesForMonth(monthKey);
    final profitLoss = controller.data.value.getProfitLossForMonth(monthKey);

    if (expenses == 0 && incomes == 0) {
      return Container();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(month),
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.calendar_month, color: TColor.primary, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildSummaryRow('Expenses', expenses),
                _buildSummaryRow('Incomes', incomes),
                const Divider(height: 16),
                _buildSummaryRow(
                  'Profit/Loss',
                  profitLoss,
                  color: profitLoss >= 0 ? TColor.secondary : TColor.third,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard(
      DateTime month,
      Map<String, double> entries,
      Color color,
      double total,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(month),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.calendar_month, color: color, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...entries.entries.map((entry) =>
                    _buildSummaryRow(entry.key, entry.value)),
                const Divider(height: 16),
                _buildSummaryRow('Total', total, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              color: color ?? TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}