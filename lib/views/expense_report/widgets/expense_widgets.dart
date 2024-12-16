import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import '../controller/expense_report_controller.dart';

class ExpenseWidgets {
  static Widget buildMonthCard(
      DateTime month,
      ExpenseReportController controller,
      ) {
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
          _buildMonthHeader(month, controller),
          ...controller.expenseItems.asMap().entries.map((entry) {
            final index = entry.key;
            final expense = entry.value;
            return _buildExpenseItem(
              expense.name,
              expense.amount.toString(),
              expense.icon,
              controller.getColorForIndex(index),
              isLast: index == controller.expenseItems.length - 1,
            );
          }),
          const Divider(thickness: 2, height: 1),
          _buildExpenseItem(
            'Total',
            controller.calculateTotalExpenses().toString(),
            Icons.summarize,
            TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  static Widget buildTotalSummaryCard(ExpenseReportController controller) {
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
            'Total Expenses Summary',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDynamicTotalSummary(controller),
        ],
      ),
    );
  }

  static Widget _buildMonthHeader(
      DateTime month,
      ExpenseReportController controller,
      ) {
    return Container(
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
            '${controller.getMonthName(month.month)} ${month.year}',
            style: TextStyle(
              color: TColor.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.calendar_month, color: TColor.primary),
        ],
      ),
    );
  }

  static Widget _buildExpenseItem(
      String title,
      String amount,
      IconData icon,
      Color color, {
        bool isLast = false,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: TColor.black, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: TColor.secondaryText, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. $amount',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDynamicTotalSummary(ExpenseReportController controller) {
    List<Widget> rows = [];
    for (int i = 0; i < controller.expenseItems.length; i += 3) {
      List<Widget> rowItems = controller.expenseItems
          .skip(i)
          .take(3)
          .map((expense) => Expanded(
        child: _buildTotalItem(
          expense.name,
          expense.amount.toString(),
          expense.icon,
        ),
      ))
          .toList();

      while (rowItems.length < 3) {
        rowItems.add(const Expanded(child: SizedBox.shrink()));
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(children: rowItems),
        ),
      );
    }

    return Column(children: rows);
  }

  static Widget _buildTotalItem(String label, String amount, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: TColor.primary.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}