import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:evoucher/views/home/home_dashboard/all_ticket_sales_report/all_ticket_sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/color_extension.dart';

class TransactionReportScreen extends StatefulWidget {
  @override
  State<TransactionReportScreen> createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  DateTime fromDate = DateTime(2024, 11, 1);
  DateTime toDate = DateTime(2024, 12, 13);
  final TransactionController transactionController =
      Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Ticket Sales Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          'From Date',
                          fromDate,
                          (date) => setState(() => fromDate = date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateSelector(
                          'To Date',
                          toDate,
                          (date) => setState(() => toDate = date),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.print, size: 20),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // In TransactionReportScreen
            Expanded(
              child: Obx(
                () => transactionController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: transactionController.transactions.length,
                        itemBuilder: (context, index) {
                          return CollapsibleTransactionCard(
                            transaction:
                                transactionController.transactions[index],
                            index: index,
                            controller: transactionController,
                          );
                        },
                      ),
              ),
            ),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      String label, DateTime selectedDate, Function(DateTime) onChanged) {
    return DateSelector2(
        fontSize: 14,
        initialDate: selectedDate,
        onDateChanged: (date) {
          onChanged(date);
          // Format dates as required by API (YYYY-MM-DD)
          String formattedFromDate = fromDate.toString().split(' ')[0];
          String formattedToDate = toDate.toString().split(' ')[0];
          transactionController.fetchTransactions(
            fromDate: formattedFromDate,
            toDate: formattedToDate,
          );
        },
        label: label);
  }

  Widget _buildTransactionInfo(String label, double amount, Color color) {
    return Expanded(
      child: Column(
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
            'Rs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTotalItem(
              'Total Purchases',
              transactionController.parseAmount(
                  transactionController.grandTotals['total_purchases'] ??
                      '0.00'),
              TColor.third,
            ),
            _buildTotalItem(
              'Total Sales',
              transactionController.parseAmount(
                  transactionController.grandTotals['total_sales'] ?? '0.00'),
              TColor.secondary,
            ),
            _buildTotalItem(
              'Total P/L',
              transactionController.parseAmount(
                  transactionController.grandTotals['total_profit_loss'] ??
                      '0.00'),
              TColor.secondary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTotalItem(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            'Rs ${amount.toStringAsFixed(1)}',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CollapsibleTransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final int index;
  final TransactionController controller;

  const CollapsibleTransactionCard({
    Key? key,
    required this.transaction,
    required this.index,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.expandedStates[index];

      return Column(
        children: [
          // Detailed View (Visible when expanded)
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                border: Border.all(color: TColor.primary.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transaction['details'].length,
                itemBuilder: (context, detailIndex) {
                  final detail = transaction['details'][detailIndex];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColor.readOnlyTextField.withOpacity(0.7),
                      border: detailIndex < transaction['details'].length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: TColor.primary.withOpacity(0.1),
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  detail['voucherNo'],
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Customer: ${detail['customerAccount']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Supplier: ${detail['supplierAccount']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person_pin_outlined,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                detail['paxName'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: TColor.primaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildAmountColumn(
                                  'Purchase',
                                  'Rs ${detail['pAmount']}',
                                  TColor.third,
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: TColor.primary.withOpacity(0.1),
                                ),
                                _buildAmountColumn(
                                  'Sale',
                                  'Rs ${detail['sAmount']}',
                                  TColor.secondary,
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: TColor.primary.withOpacity(0.1),
                                ),
                                _buildAmountColumn(
                                  'P/L',
                                  'Rs ${detail['pnl']}',
                                  detail['pnl'] > 0
                                      ? TColor.secondary
                                      : TColor.third,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Main Transaction Card (keeping the existing code)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: TColor.white,
              border: Border.all(
                color: TColor.primary.withOpacity(0.2),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: TColor.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction['date'],
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${transaction['entries']} Entries',
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColor.primary,
                            ),
                            onPressed: () => controller.toggleExpanded(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTransactionInfo(
                          'Purchase', transaction['purchase'], TColor.third),
                      _buildTransactionInfo(
                          'Sale', transaction['sale'], TColor.secondary),
                      _buildTransactionInfo(
                        'Profit/Loss',
                        transaction['profit'],
                        transaction['profit'] > 0
                            ? TColor.secondary
                            : TColor.third,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionInfo(String label, double amount, Color color) {
    return Expanded(
      child: Column(
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
            'Rs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountColumn(String label, String amount, Color amountColor) {
    return Expanded(
      child: Column(
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
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
