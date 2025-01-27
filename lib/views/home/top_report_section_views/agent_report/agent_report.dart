// transactions_screen.dart
import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/date_selecter.dart';
import 'package:evoucher_new/views/home/top_report_section_views/agent_report/agent_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgentReport extends StatelessWidget {
  final AgentReportController controller = Get.put(AgentReportController());

  AgentReport({super.key});

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
          Obx(() {
            if (controller.isLoading.value) {
              // Show loading indicator
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.transactions.isEmpty) {
              // Show "No records found" message
              return const Expanded(
                child: Center(
                  child: Text(
                    "No records found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            } else {
              // Show the transaction list
              return _buildTransactionsList();
            }
          }),
          _buildSummaryFooter(),
        ],
      ),
    );
  }

  // ... (keep other methods the same)

  Widget _buildTransactionsList() {
    return Expanded(
      child: Obx(
            () => controller.transactions.isEmpty
            ? Center(child: CircularProgressIndicator(color: TColor.primary))
            : ListView.builder(
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
                          (transaction['date']),
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
                        _buildAmountColumn('Credit',
                            transaction['receipt'], TColor.secondary),
                        _buildAmountColumn('Debit',
                            transaction['payment'], TColor.third),
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
            _buildSummaryItem('Total Credit',
                controller.totals['totalCredit']!.value, TColor.secondary),
            _buildSummaryItem('Total Debit',
                controller.totals['totalDebit']!.value, TColor.third),
            _buildSummaryItem(
                'Total Balance',
                controller.totals['totalBalance']!.value,
                controller.totals['totalBalance']!.value >= 0
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

Widget _buildDateSelectionBar() {
  final AgentReportController controller = Get.put(AgentReportController());
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
                  onDateChanged: (newDate) {
                    controller.updateDate(newDate);
                  },
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(width: 16),
        // ElevatedButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(Icons.print, size: 20),
        //   label: const Text('Print'),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: TColor.secondary,
        //     foregroundColor: TColor.white,
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}



// bindings.dart
