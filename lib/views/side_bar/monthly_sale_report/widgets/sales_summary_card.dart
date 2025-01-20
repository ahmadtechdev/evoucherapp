import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/color_extension.dart';
import '../controller/monthly_sale_controller.dart';

class SalesSummaryCard extends GetView<MonthlySalesController> {
  const SalesSummaryCard({super.key});

  Widget _buildTotalItem(String label, int amount, IconData icon) {
    final formattedAmount = NumberFormat('#,##0').format(amount);
    return Column(
      children: [
        Icon(icon, color: TColor.primary.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: TColor.secondaryText, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          formattedAmount,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
            'Total Sales Summary',
            style: TextStyle(
              color: TColor.primaryText,
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
                  controller.totalSales.value.ticketSales,
                  Icons.airplane_ticket,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Hotels',
                  controller.totalSales.value.hotelBookings,
                  Icons.hotel,
                ),
              ),
              Expanded(
                child: _buildTotalItem(
                  'Visas',
                  controller.totalSales.value.visaServices,
                  Icons.credit_card,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}