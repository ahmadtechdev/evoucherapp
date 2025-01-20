import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/total_monthly_expense_controller.dart';
import 'models/total_monthly_expense_model.dart';

class TotalMonthlyExpenses extends StatelessWidget {
  TotalMonthlyExpenses({super.key});

  final TotalMonthlyExpensesController controller = Get.put(TotalMonthlyExpensesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Total Monthly Expenses'),
      ),
      drawer: const CustomDrawer(currentIndex: 14),
      body: Column(
        children: [
          _buildDateSelectionHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...controller.companies.map((company) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCompanyHeader(company.name),
                      ...controller.getMonthsBetween().map((month) =>
                          _buildMonthCard(company, month)),
                      _buildCompanyTotal(company),
                      const SizedBox(height: 24),
                    ],
                  )),
                  _buildGrandTotal(),
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

  Widget _buildCompanyHeader(String companyName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        companyName,
        style: TextStyle(
          color: TColor.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMonthCard(TotalMonthlyExpensesModel company, DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final monthExpenses = company.getExpensesForMonth(monthKey);

    if (monthExpenses.isEmpty) {
      return Container(); // Skip empty months
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
                ...monthExpenses.entries.map((entry) =>
                    _buildExpenseRow(entry.key, entry.value)),
                const Divider(height: 16),
                _buildMonthTotalRow(controller.calculateCompanyTotalForMonth(
                    company, monthKey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(String expenseType, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            expenseType,
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthTotalRow(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          total.toStringAsFixed(2),
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyTotal(TotalMonthlyExpensesModel company) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${company.name} Total: ',
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'PKR ${company.getTotalExpenses().toStringAsFixed(2)}',
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrandTotal() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Grand Total',
              style: TextStyle(
                color: TColor.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PKR ${controller.calculateTotalExpenses().toStringAsFixed(2)}',
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}