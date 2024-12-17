import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/color_extension.dart';

class DateSelector2Controller extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;

  void setDate(DateTime date) {
    selectedDate.value = date;
  }
}



class DateSelector2 extends StatelessWidget {
  final double fontSize;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;
  final bool selectMonthOnly;
  final bool readonly;

  final DateSelector2Controller controller = Get.put(DateSelector2Controller());

  DateSelector2({
    super.key,
    required this.fontSize,
    required this.initialDate,
    required this.onDateChanged,
    this.label = "",
    this.selectMonthOnly = false,
    this.readonly = false,
  }) {
    // Initialize the controller's date with the provided initial date
    controller.setDate(initialDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (selectMonthOnly) {
      // Select Year
      final int? pickedYear = await showDialog<int>(
        context: context,
        builder: (context) => _yearPickerDialog(context),
      );

      if (pickedYear != null) {
        // Select Month
        final int? pickedMonth = await showDialog<int>(
          context: context,
          builder: (context) => _monthPickerDialog(context),
        );

        if (pickedMonth != null) {
          controller.setDate(DateTime(pickedYear, pickedMonth));
          onDateChanged(controller.selectedDate.value);
        }
      }
    } else {
      // Default Date Picker
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => _buildDatePickerTheme(context, child),
      );

      if (picked != null) {
        controller.setDate(picked);
        onDateChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              onTap: readonly ? null : () => _selectDate(context),
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
                      selectMonthOnly
                          ? DateFormat('MMMM yyyy').format(controller.selectedDate.value)
                          : DateFormat('dd/MM/yyyy').format(controller.selectedDate.value),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: TColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: fontSize,
                      color: TColor.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Year Picker Dialog
  Widget _yearPickerDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Select Year", style: TextStyle(color: TColor.primaryText)),
      content: SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            int year = DateTime.now().year - 5 + index;
            return ListTile(
              title: Text(year.toString(), style: TextStyle(color: TColor.primaryText)),
              onTap: () => Navigator.pop(context, year),
            );
          },
        ),
      ),
    );
  }

  /// Month Picker Dialog
  Widget _monthPickerDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Select Month", style: TextStyle(color: TColor.primaryText)),
      content: SizedBox(
        height: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, index + 1),
              child: Container(
                color: TColor.black.withOpacity(0.3),
                child: Center(
                  child: Text(
                    DateFormat.MMMM().format(DateTime(0, index + 1)),
                    style: TextStyle(color: TColor.primaryText),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Date Picker Theme
  Widget _buildDatePickerTheme(BuildContext context, Widget? child) {
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
          style: TextButton.styleFrom(foregroundColor: TColor.third),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
