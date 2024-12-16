import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/color_extension.dart';

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({super.key});

  @override
  State<TransactionReportScreen> createState() => _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  DateTime fromDate = DateTime(2024, 11, 1);
  DateTime toDate = DateTime(2024, 12, 13);

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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTransactionCard(
                    date: 'Dec 06, 2024',
                    entries: 2,
                    purchase: 310,
                    sale: 460,
                    profit: 150,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionCard(
                    date: 'Dec 02, 2024',
                    entries: 1,
                    purchase: 750,
                    sale: 750,
                    profit: 0,
                  ),
                ],
              ),
            ),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime selectedDate, Function(DateTime) onChanged) {
    return DateSelector2(fontSize: 14, initialDate: selectedDate, onDateChanged: onChanged, label: label);
  }

  Widget _buildTransactionCard({
    required String date,
    required int entries,
    required double purchase,
    required double sale,
    required double profit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
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
                  date,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$entries Entries',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTransactionInfo('Purchase', purchase, TColor.third),
                _buildTransactionInfo('Sale', sale, TColor.secondary),
                _buildTransactionInfo(
                  'Profit/Loss',
                  profit,
                  profit > 0
                      ? TColor.secondary
                      : (profit < 0 ? TColor.third :TColor.primaryText), // Check for zero and set color to black
                )
                ,
              ],
            ),
          ],
        ),
      ),
    );
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
          _buildTotalItem('Total Purchases', 1060.00, TColor.third),
          _buildTotalItem('Total Sales', 1210.00, TColor.secondary),
          _buildTotalItem('Total P/L', 150.00, TColor.secondary),
        ],
      ),
    );
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
}