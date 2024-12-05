
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/dart_selector2.dart';
import '../../common_widget/round_textfield.dart';

class VoucherHeader extends StatelessWidget {
  final String title;
  final DateTime selectedDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const VoucherHeader({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.searchController,
    required this.onSearchChanged,
  });

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
              DateSelector2(
                fontSize: 16,
                initialDate: selectedDate,
                label: "From Month:",
                onDateChanged: onFromDateChanged,
              ),
              const SizedBox(width: 5),
              DateSelector2(
                fontSize: 16,
                initialDate: selectedDate,
                label: "To Month:    ",
                onDateChanged: onToDateChanged,
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColor.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'FROM: WED, 08-JAN-2020 | TO: WED, 13-NOV-2024',
            style: TextStyle(
              fontSize: 12,
              color: TColor.third,
              fontWeight: FontWeight.w500,
            ),
          ),

          // TextField(
          //   controller: searchController,
          //   onChanged: onSearchChanged,
          //   decoration: InputDecoration(
          //     hintText: 'Search by description...',
          //     hintStyle: TextStyle(color: TColor.placeholder),
          //     filled: true,
          //     fillColor: TColor.textfield,
          //     prefixIcon: Icon(Icons.search, color: TColor.placeholder),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: BorderSide.none,
          //     ),
          //     contentPadding: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 12,
          //     ),
          //   ),
          // ),
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