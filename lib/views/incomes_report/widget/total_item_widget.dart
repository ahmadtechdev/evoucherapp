import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';

class TotalItemWidget extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;

  const TotalItemWidget({
    Key? key,
    required this.label,
    required this.amount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: TColor.primary.withOpacity(0.8), size: 22),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}