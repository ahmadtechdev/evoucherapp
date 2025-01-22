// transactions_screen.dart
import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/date_selecter.dart';
import 'package:evoucher_new/views/home/top_report_section_views/agent_report/agent_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentReport extends StatelessWidget {
  final AgentReportController controller = Get.put(AgentReportController());

  AgentReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: TColor.white,
        centerTitle: true,
        title: const Text('Agent Report'),
        backgroundColor: TColor.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDateSelectionBar(),
          _buildTransactionsList(),
          _buildSummaryFooter(),
        ],
      ),
    );
  }

  Widget _buildDateSelectionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DateSelector(
                    fontSize: 14,
                    vpad: 14,
                    initialDate: DateTime.now(),
                    label: "DATE:",
                    onDateChanged: (newDate) {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: controller.printTransactions,
            icon: const Icon(Icons.print, size: 20),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondary,
              foregroundColor: TColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy')
                              .format(DateTime.parse(transaction['date'])),
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: transaction['balance'] >= 0
                                ? TColor.secondary.withOpacity(0.1)
                                : TColor.third.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '₹${transaction['balance'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction['balance'] >= 0
                                  ? TColor.secondary
                                  : TColor.third,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      transaction['name'],
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction['email'],
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAmountColumn('Receipt', transaction['receipt'],
                            TColor.secondary),
                        _buildAmountColumn(
                            'Payment', transaction['payment'], TColor.third),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
                'Total Receipt', controller.totalReceipt, TColor.secondary),
            _buildSummaryItem(
                'Total Payment', controller.totalPayment, TColor.third),
            _buildSummaryItem(
                'Closing Balance',
                controller.closingBalance,
                controller.closingBalance >= 0
                    ? TColor.secondary
                    : TColor.third),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountColumn(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// bindings.dart
