import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';

class DateSelector2 extends StatelessWidget {
  final double fontSize;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;
  final bool selectMonthOnly;
  final bool readonly;

  DateSelector2({
    super.key,
    required this.fontSize,
    required this.initialDate,
    required this.onDateChanged,
    this.label = "",
    this.selectMonthOnly = false,
    this.readonly = false,
  }) : selectedDate = initialDate.obs;

  final Rx<DateTime> selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    if (readonly) return;

    if (selectMonthOnly) {
      await _selectMonthOnly(context);
    } else {
      await _selectFullDate(context);
    }
  }

  Future<void> _selectFullDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstAllowedDate = DateTime(2020, 1, 1);
    final DateTime lastAllowedDate = DateTime(now.year + 1, 12, 31);

    DateTime validInitialDate = selectedDate.value;
    if (validInitialDate.isAfter(lastAllowedDate)) {
      validInitialDate = lastAllowedDate;
    }
    if (validInitialDate.isBefore(firstAllowedDate)) {
      validInitialDate = firstAllowedDate;
    }

    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: validInitialDate,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: TColor.primary,
                onPrimary: TColor.white,
                surface: TColor.white,
                onSurface: TColor.primaryText,
                secondary: TColor.secondary,
              ),
              dialogBackgroundColor: TColor.white,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: TColor.third,
                ),
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );

      if (picked != null) {
        selectedDate.value = picked;
        onDateChanged(picked);
      }
    } catch (e) {
      debugPrint('Error in date picker: $e');
    }
  }

  Future<void> _selectMonthOnly(BuildContext context) async {
    final now = DateTime.now();
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Year",
            style: TextStyle(color: TColor.primaryText),
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: now.year - 2020 + 2, // Years from 2020 to next year
              itemBuilder: (context, index) {
                int year = 2020 + index;
                return ListTile(
                  title: Text(
                    year.toString(),
                    style: TextStyle(color: TColor.primaryText),
                  ),
                  onTap: () => Navigator.pop(context, year),
                );
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null) {
      final int? pickedMonth = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Month",
              style: TextStyle(color: TColor.primaryText),
            ),
            content: SizedBox(
              height: 300,
              width: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.pop(context, index + 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('MMM').format(DateTime(2022, index + 1)),
                          style: TextStyle(color: TColor.primaryText),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );

      if (pickedMonth != null) {
        final newDate = DateTime(pickedYear, pickedMonth);
        selectedDate.value = newDate;
        onDateChanged(newDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: TColor.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty)
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
                    Expanded(
                      child: Text(
                        selectMonthOnly
                            ? DateFormat('MMMM yyyy').format(selectedDate.value)
                            : DateFormat('dd/MM/yyyy').format(selectedDate.value),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: TColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: fontSize,
                      color: TColor.primary,
                    ),
                    const SizedBox(width: 4),
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
