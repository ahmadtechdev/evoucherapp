import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/dart_selector2.dart';
import '../../../common_widget/round_text_field.dart';

class VoucherHeader extends StatelessWidget {
  final String title;
  final DateTime selectedDate;
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  VoucherHeader({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.searchController,
    required this.onSearchChanged,
    DateTime? fromDate,
    DateTime? toDate,
  })  : fromDate =
            fromDate ?? DateTime.now().subtract(const Duration(days: 90)),
        toDate = toDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      color: TColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DateSelector2(
                  fontSize: 16,
                  initialDate: fromDate,
                  label: "From Date:",
                  onDateChanged: onFromDateChanged,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: DateSelector2(
                  fontSize: 16,
                  initialDate: toDate,
                  label: "To Date:",
                  onDateChanged: onToDateChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'FROM: ${DateFormat('EEE, dd-MMM-yyyy').format(fromDate)} | TO: ${DateFormat('EEE, dd-MMM-yyyy').format(toDate)}',
              style: TextStyle(
                fontSize: 12,
                color: TColor.third,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SearchTextField(
            hintText: 'Search...',
            controller: searchController,
            onChange: onSearchChanged,
          ),
        ],
      ),
    );
  }
}
