
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/dart_selector2.dart';


class HotelSaleRegisterScreen extends StatelessWidget {
  HotelSaleRegisterScreen({super.key});

  // Dummy data for demonstration
  final List<Map<String, dynamic>> bookingData = [
    {
      'date': DateTime.now(),
      'bookings': [
        {
          'v': 1,
          'pax': 2,
          'pnr': 'ABCD123',
          'ticketNo': 'TKT001',
          'account': 'John Doe',
          'airline': 'Emirates',
          'sector': 'DXB-LHR',
          'buying': 1500.0,
          'selling': 2000.0,
          'profit': 500.0,
          'supplier': 'Travel Agency X'
        },
        {
          'v': 2,
          'pax': 1,
          'pnr': 'WXYZ456',
          'ticketNo': 'TKT002',
          'account': 'Jane Smith',
          'airline': 'Qatar Airways',
          'sector': 'DOH-JFK',
          'buying': 2000.0,
          'selling': 2500.0,
          'profit': 500.0,
          'supplier': 'Travel Agency Y'
        }
      ]
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'bookings': [
        {
          'v': 3,
          'pax': 3,
          'pnr': 'QWER789',
          'ticketNo': 'TKT003',
          'account': 'Alice Johnson',
          'airline': 'Etihad',
          'sector': 'AUH-CDG',
          'buying': 1800.0,
          'selling': 2300.0,
          'profit': 500.0,
          'supplier': 'Travel Agency Z'
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        title: Text(
          'Detailed Booking Report',
          style: TextStyle(color: TColor.primaryText),
        ),
        backgroundColor: TColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Date Range Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DateSelector2(
                    fontSize: 14,
                    initialDate: DateTime.now().subtract(const Duration(days: 30)),
                    onDateChanged: (DateTime date) {
                      // Handle start date change
                    },
                    label: 'From Date',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DateSelector2(
                    fontSize: 14,
                    initialDate: DateTime.now(),
                    onDateChanged: (DateTime date) {
                      // Handle end date change
                    },
                    label: 'To Date',
                  ),
                ),
              ],
            ),
          ),

          // Booking List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: bookingData.length,
              itemBuilder: (context, index) {
                return _buildDailyBookingSection(bookingData[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildTotalSummaryFAB(),
    );
  }

  Widget _buildDailyBookingSection(Map<String, dynamic> dailyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            DateFormat('dd MMMM yyyy').format(dailyData['date']),
            style: TextStyle(
              color: TColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Daily Summary Card
        _buildDailySummaryCard(dailyData['bookings']),

        // Booking Cards
        ...dailyData['bookings'].map<Widget>((booking) => _buildBookingCard(booking)),

        // Spacing
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDailySummaryCard(List<dynamic> bookings) {
    // Calculate daily totals
    int totalPax = bookings.fold(0, (sum, booking) => sum + booking['pax'] as int);
    double totalBuying = bookings.fold(0.0, (sum, booking) => sum + booking['buying']);
    double totalSelling = bookings.fold(0.0, (sum, booking) => sum + booking['selling']);
    double totalProfit = bookings.fold(0.0, (sum, booking) => sum + booking['profit']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('Pax', totalPax.toString(), TColor.primary),
          _buildSummaryItem('Buying', 'Rs. ${totalBuying.toStringAsFixed(0)}', TColor.secondary),
          _buildSummaryItem('Selling', 'Rs. ${totalSelling.toStringAsFixed(0)}', TColor.third),
          _buildSummaryItem('Profit', 'Rs. ${totalProfit.toStringAsFixed(0)}', TColor.fourth),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryText.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  'V # ${booking['v']}',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  booking['pnr'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Booking Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Ticket #', booking['ticketNo']),
                _buildDetailRow('Account', booking['account']),
                _buildDetailRow('Airline', booking['airline']),
                _buildDetailRow('Sector', booking['sector']),
                _buildDetailRow('Supplier', booking['supplier']),
                const Divider(color: Colors.grey, height: 24),
                _buildFinancialRow('Buying', 'Rs. ${booking['buying'].toStringAsFixed(0)}', TColor.third),
                _buildFinancialRow('Selling', 'Rs. ${booking['selling'].toStringAsFixed(0)}', TColor.secondary),
                _buildFinancialRow('Profit', 'Rs. ${booking['profit'].toStringAsFixed(0)}', TColor.primary),
              ],
            ),
          ),

          // Footer (Optional CTA or additional info)
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   decoration: BoxDecoration(
          //     color: TColor.textField,
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(16),
          //       bottomRight: Radius.circular(16),
          //     ),
          //   ),
          //   child: Center(
          //     child: Text(
          //       'Booking Confirmed',
          //       style: TextStyle(
          //         color: TColor.secondary,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
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


  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: TColor.secondaryText,
  //             fontSize: 14,
  //           ),
  //         ),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: TColor.primaryText,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFinancialRow(String label, String value, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: TColor.secondaryText,
  //             fontSize: 14,
  //           ),
  //         ),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTotalSummaryFAB() {
    return FloatingActionButton(
      onPressed: _showTotalSummaryBottomSheet,
      backgroundColor: TColor.primary,
      child: const Icon(Icons.summarize),
    );
  }

  void _showTotalSummaryBottomSheet() {
    // Calculate total summary
    int totalPax = bookingData.expand((daily) => daily['bookings']).fold(0, (sum, booking) => sum + booking['pax'] as int);
    double totalBuying = bookingData.expand((daily) => daily['bookings']).fold(0.0, (sum, booking) => sum + booking['buying']);
    double totalSelling = bookingData.expand((daily) => daily['bookings']).fold(0.0, (sum, booking) => sum + booking['selling']);
    double totalProfit = bookingData.expand((daily) => daily['bookings']).fold(0.0, (sum, booking) => sum + booking['profit']);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Summary',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStatItem('Total Pax', totalPax.toString(), TColor.secondary),
                _buildSummaryStatItem('Total Buying', 'Rs. ${totalBuying.toStringAsFixed(0)}', TColor.third),
                _buildSummaryStatItem('Total Selling', 'Rs. ${totalSelling.toStringAsFixed(0)}', TColor.fourth),
                _buildSummaryStatItem('Total Profit', 'Rs. ${totalProfit.toStringAsFixed(0)}', TColor.primary),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSummaryStatItem(String label, String value, Color color) {
    return Column(
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
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}