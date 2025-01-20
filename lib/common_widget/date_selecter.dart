import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';

class DateSelector extends StatefulWidget {
  final double fontSize;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;
  final double vpad;

  const DateSelector({
    super.key,
    required this.fontSize,
    required this.initialDate,
    required this.onDateChanged,
    this.label = "SALES ON:",
    this.vpad = 12,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late final Rx<DateTime> selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate.obs;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: widget.vpad),
        decoration: BoxDecoration(
          color: TColor.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TColor.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate.value),
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          color: TColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today,
                        size: widget.fontSize,
                        color: TColor.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
