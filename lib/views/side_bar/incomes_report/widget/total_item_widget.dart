import 'package:flutter/material.dart';
import '../../../../common/color_extension.dart';

class TotalItemWidget extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final String total;

  const TotalItemWidget({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: TColor.primary.withOpacity(0.8), size: 22),
        const SizedBox(height: 8),
        // Use Flexible or Expanded to handle long label text
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
