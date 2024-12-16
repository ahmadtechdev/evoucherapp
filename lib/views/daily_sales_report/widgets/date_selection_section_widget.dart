// lib/views/widgets/date_selection_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/dart_selector2.dart';

class DateSelectionSection extends StatelessWidget {
  final DateTimeRange selectedDateRange;
  final Function(DateTimeRange) onDateChanged;

  const DateSelectionSection({required this.selectedDateRange, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateSelector2(
                  label: 'From Date',
                  initialDate: selectedDateRange.start,
                  onDateChanged: (date) => onDateChanged(DateTimeRange(start: date, end: selectedDateRange.end)), fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DateSelector2(
                  label: 'To Date',
                  initialDate: selectedDateRange.end,
                  onDateChanged: (date) => onDateChanged(DateTimeRange(start: selectedDateRange.start, end: date)), fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('From ${DateFormat('E, dd MMM yyyy').format(selectedDateRange.start)} To ${DateFormat('E, dd MMM yyyy').format(selectedDateRange.end)}',
              style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}