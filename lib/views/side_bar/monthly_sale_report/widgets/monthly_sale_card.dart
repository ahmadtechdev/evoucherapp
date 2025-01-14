import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../common/color_extension.dart';
import '../controller/monthly_sale_controller.dart';

class MonthlySalesCard extends StatelessWidget {
  final DateTime month;
  final MonthlySalesController controller;

  const MonthlySalesCard({
    super.key,
    required this.month,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final salesData = controller.getSalesData(month);

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
          _buildHeader(),
          _buildVoucherItem(
            'Ticket Sales',
            NumberFormat('#,##0').format(salesData.ticketSales),
            Icons.airplane_ticket,
            TColor.secondary,
          ),
          _buildVoucherItem(
            'Hotel Bookings',
            NumberFormat('#,##0').format(salesData.hotelBookings),
            Icons.hotel,
            TColor.third,
          ),
          _buildVoucherItem(
            'Visa Services',
            NumberFormat('#,##0').format(salesData.visaServices),
            Icons.credit_card,
            TColor.fourth,
          ),
          const Divider(thickness: 1, height: 1),
          _buildVoucherItem(
            'Total',
            NumberFormat('#,##0').format(salesData.total),
            Icons.summarize,
            TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildVoucherItem(
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
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
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
}
