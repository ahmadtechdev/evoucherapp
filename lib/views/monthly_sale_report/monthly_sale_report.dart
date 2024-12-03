import 'dart:math';

import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';

class MonthlySalesReport extends StatefulWidget {
  const MonthlySalesReport({super.key});

  @override
  State<MonthlySalesReport> createState() => _MonthlySalesReportState();
}

class _MonthlySalesReportState extends State<MonthlySalesReport> {
  DateTime fromDate = DateTime(2023, 12);
  DateTime toDate = DateTime(2024, 12);
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
      backgroundColor: TColor.textfield,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Monthly Sales Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 6),
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
                    backgroundColor: TColor.secondary,
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
        color: Colors.white,
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
          _buildVoucherItem(
            'Ticket Sales',
            _getDummyAmount(),
            Icons.airplane_ticket,
            TColor.secondary,
          ),
          _buildVoucherItem(
            'Hotel Bookings',
            _getDummyAmount(),
            Icons.hotel,
            TColor.third,
          ),
          _buildVoucherItem(
            'Visa Services',
            _getDummyAmount(),
            Icons.credit_card,
            TColor.fourth,
          ),
          const Divider(thickness: 1, height: 1), // Optional: Divider before the total
          _buildVoucherItem(
            'Total',
            _calculateTotal(),
            Icons.summarize,
            TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

// Dummy method to calculate the total
  String _calculateTotal() {
    return _getDummyAmount() * 3; // Replace with actual calculation logic
  }

  Widget _buildVoucherItem(
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
                    style: TextStyle(color: TColor.secondaryText, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Rs. $amount',
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Icon(Icons.arrow_forward_ios, color: TColor.secondaryText, size: 16),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Sales Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTotalItem(
                  'Tickets',
                  '1,188,292',
                  Icons.airplane_ticket,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Hotels',
                  '747,485',
                  Icons.hotel,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Visas',
                  '191,457',
                  Icons.credit_card,
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
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
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

  String _getDummyAmount() {
    return (Random().nextInt(300000)).toString();
  }
}
