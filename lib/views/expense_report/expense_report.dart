import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';

class ExpenseComparisonReport extends StatefulWidget {
  const ExpenseComparisonReport({super.key});

  @override
  ExpenseComparisonReportState createState() => ExpenseComparisonReportState();
}

class ExpenseComparisonReportState extends State<ExpenseComparisonReport> {
  DateTime fromDate = DateTime(2024, 1);
  DateTime toDate = DateTime(2024, 11);

  List<DateTime> _getMonthsBetween() {
    List<DateTime> months = [];
    DateTime current = fromDate;
    while (current.isBefore(toDate) ||
        current.month == toDate.month && current.year == toDate.year) {
      months.add(current);
      current = DateTime(current.year + (current.month == 12 ? 1 : 0),
          current.month == 12 ? 1 : current.month + 1);
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    var months = _getMonthsBetween();

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Expenses Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 7),
      body: Column(
        children: [
          Container(
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
                      child: DateSelector2(
                        label: 'From Month',
                        fontSize: 12,
                        initialDate: fromDate,
                        selectMonthOnly:true,
                        onDateChanged: (DateTime picked) {
                          setState(() {
                            fromDate = picked;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DateSelector2(
                        label: 'To Month',
                        fontSize: 12,
                        initialDate: toDate,
                        selectMonthOnly:true,
                        onDateChanged: (DateTime picked) {
                          setState(() {
                            toDate = picked;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      months = _getMonthsBetween();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4CAF50),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Generate Report',
                      style: TextStyle(color: Colors.white)),
                ),
                Text(
                  'From ${DateFormat('MMM yyyy').format(fromDate)} To ${DateFormat('MMM yyyy').format(toDate)}',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: months.length + 1, // +1 for the summary card
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildTotalSummaryCard();
                }
                return _buildMonthCard(months[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard(DateTime month) {
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
                  '${_getMonthName(month.month)} ${month.year}',
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
          _buildExpenseItem(
            'Staff Salaries',
            '0.00',
            Icons.account_balance_wallet,
            TColor.primary,
          ),
          _buildExpenseItem(
            'Bonus Allowance',
            '0.00',
            Icons.paid,
            TColor.secondary,
          ),
          _buildExpenseItem(
            'Fuel Allowance',
            '8,000.00',
            Icons.local_gas_station,
            TColor.third,
          ),
          _buildExpenseItem(
            'Incentive Allowance',
            '0.00',
            Icons.monetization_on,
            TColor.fourth,
          ),
          _buildExpenseItem(
            'Mobile Allowance',
            '0.00',
            Icons.smartphone,
            TColor.primary,
          ),
          _buildExpenseItem(
            'Other Allowance',
            '0.00',
            Icons.list,
            TColor.secondary,
          ),
          _buildExpenseItem(
            'Staaf Salary Pzz',
            '0.00',
            Icons.account_balance_wallet,
            TColor.third,
            isLast: true,
          ),
          const Divider(thickness: 2, height: 1),
          // Optional: Divider before the total
          _buildExpenseItem(
            'Total',
            '54321',
            Icons.summarize,
            TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      String title, String amount, IconData icon, Color color,
      {bool isLast = false}) {
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
                Text(title,
                    style:
                        TextStyle(color: TColor.secondaryText, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Rs. $amount',
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummaryCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Staff Salaries',
                  '0.00',
                  Icons.account_balance_wallet,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Bonus Allowance',
                  '0.00',
                  Icons.paid,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Fuel Allowance',
                  '8,000.00',
                  Icons.local_gas_station,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Incentive Allowance',
                  '0.00',
                  Icons.monetization_on,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Mobile Allowance',
                  '0.00',
                  Icons.smartphone,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Other Allowance',
                  '0.00',
                  Icons.list,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Staaf Salary Pzz',
                  '0.00',
                  Icons.account_balance_wallet,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Discount',
                  '2,269,970.00',
                  Icons.local_offer,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'HUSSNAIN ALI ISB EMP',
                  '45,000.00',
                  Icons.person,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String amount, IconData icon) {
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

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
