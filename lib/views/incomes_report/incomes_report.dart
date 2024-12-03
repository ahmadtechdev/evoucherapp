import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';

class IncomesComparisonReport extends StatefulWidget {
  const IncomesComparisonReport({super.key});

  @override
  IncomesComparisonReportState createState() => IncomesComparisonReportState();
}

class IncomesComparisonReportState extends State<IncomesComparisonReport> {
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
        title: const Text('Incomes Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 8),
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
                        selectMonthOnly: true,
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
                        selectMonthOnly: true,
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
          _buildIncomeItem(
            'Package Income',
            '396,230.00',
            Icons.receipt,
            TColor.primary,
          ),
          _buildIncomeItem(
            'Ticket Income',
            '72,698.00',
            Icons.monetization_on,
            TColor.secondary,
          ),
          _buildIncomeItem(
            'Hotel Incomes',
            '241,671.00',
            Icons.hotel,
            TColor.third,
          ),
          _buildIncomeItem(
            'Visa Incomes',
            '53,786.00',
            Icons.credit_card,
            TColor.fourth,
          ),
          _buildIncomeItem(
            'Other Incomes',
            '0.00',
            Icons.attach_money,
            TColor.primary,
          ),
          _buildIncomeItem(
            'Transport Income',
            '-22,210.00',
            Icons.directions_car,
            TColor.secondary,
            isLast: true,
          ),
          _buildIncomeItem(
            'Fine Penalties',
            '0.00',
            Icons.directions_car,
            TColor.secondary,
            isLast: true,
          ),
          _buildIncomeItem(
            'other Penalties',
            '-2.00',
            Icons.directions_car,
            TColor.secondary,
            isLast: true,
          ),
          const Divider(thickness: 2, height: 1),
          // Optional: Divider before the total
          _buildIncomeItem(
            'Total',
            '396,230.00',
            Icons.summarize,
            TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeItem(
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
                Text(
                  'Rs. $amount',
                  style: TextStyle(
                    color: (double.tryParse(amount.replaceAll(',', '')) ?? 0) <
                            0
                        ? TColor.third
                        : (double.tryParse(amount.replaceAll(',', '')) ?? 0) > 0
                            ? TColor.secondary
                            : TColor.primaryText,
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

  Widget _buildTotalSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Incomes Summary',
            style: TextStyle(
              color: TColor.white,
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
                  'Package Income',
                  '396,230.00',
                  Icons.receipt,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Ticket Income',
                  '72,698.00',
                  Icons.monetization_on,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Hotel Incomes',
                  '241,671.00',
                  Icons.hotel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Visa Incomes',
                  '53,786.00',
                  Icons.credit_card,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Other Incomes',
                  '2,793.00',
                  Icons.attach_money,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Transport Income',
                  '22,210.00',
                  Icons.directions_car,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Fine Penalties',
                  '53,786.00',
                  Icons.close,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Other Penalties',
                  '2,793.00',
                  Icons.devices_other,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  '',
                  '',
                  Icons.do_not_disturb_on_total_silence,
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
        Icon(icon, color: TColor.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: TColor.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: TColor.white,
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
