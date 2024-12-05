import 'package:flutter/material.dart';
import '../../../../common/color_extension.dart';

class IncomeCardWidget extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final bool isLast;

  const IncomeCardWidget({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(color: TColor.secondaryText, fontSize: 14)
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. $amount',
                  style: TextStyle(
                    color: (double.tryParse(amount.replaceAll(',', '')) ?? 0) < 0
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
}