// widgets/sales_summary_card.dart
import 'package:flutter/material.dart';
import '../../../../common/color_extension.dart';

class SalesSummaryCard extends StatelessWidget {
  const SalesSummaryCard({Key? key}) : super(key: key);

  Widget _buildTotalItem(String label, String amount, IconData icon) {
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

  @override
  Widget build(BuildContext context) {
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
}