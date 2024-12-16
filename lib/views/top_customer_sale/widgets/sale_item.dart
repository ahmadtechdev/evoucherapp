import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/color_extension.dart';

class SaleItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const SaleItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${NumberFormat('#,##0.00').format(amount)}',
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