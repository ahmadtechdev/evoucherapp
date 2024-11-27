import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

class DateSelector2 extends StatelessWidget {
  final double fontSize;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;

  DateSelector2({
    super.key,
    required this.fontSize,
    required this.initialDate,
    required this.onDateChanged,
    this.label = "",
  });

  final Rx<DateTime> selectedDate = DateTime.now().obs; // Observable for state management

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary, // Primary color for headers and selected date
              onPrimary: TColor.white, // Text color on primary color
              surface: TColor.white, // Background color for the date picker surface
              onSurface: TColor.primaryText, // Text color for dates
              secondary: TColor.secondary, // Color for the day selected by the user
            ),
            dialogBackgroundColor: TColor.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColor.third, // "Cancel" and "OK" button color
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked; // Update observable value
      onDateChanged(picked); // Notify the parent of the date change
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedDate.value = initialDate; // Initialize with the provided initial date

    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: TColor.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TColor.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(selectedDate.value),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: TColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today,
                      size: fontSize,
                      color: TColor.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
