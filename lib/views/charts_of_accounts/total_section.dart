
// widgets/total_section.dart
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class TotalSection extends StatelessWidget {
  final double totalDebit;
  final double totalCredit;

  const TotalSection({
    super.key,
    required this.totalDebit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.primary.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: TColor.primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Debit',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                totalDebit.toStringAsFixed(2),
                style: TextStyle(
                  color: TColor.third,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total Credit',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                totalCredit.toStringAsFixed(2),
                style: TextStyle(
                  color: TColor.fourth,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}