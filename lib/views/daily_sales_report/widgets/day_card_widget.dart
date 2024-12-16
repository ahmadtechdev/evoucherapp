// lib/views/day_card_widget.dart
import 'package:flutter/material.dart';

import '../models/daily_sales_report_model.dart';

class DayCard extends StatefulWidget {
  final SaleEntry dayData;

  const DayCard({super.key, required this.dayData});

  @override
  DayCardState createState() => DayCardState();
}

class DayCardState extends State<DayCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.dayData.summary;
    final details = widget.dayData.details;

    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            // Header and Toggle Button
            // (Same as before)
            if (isExpanded) ...[
              // Expandable details
              // (Same as before)
            ],
            // Summary Rows
            // (Same as before)
          ],
        ));
  }
}
