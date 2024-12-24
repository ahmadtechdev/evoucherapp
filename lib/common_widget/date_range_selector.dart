import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class CustomDateRangeSelector extends StatelessWidget {
  final DateTimeRange dateRange;
  final Function(DateTimeRange) onDateRangeChanged;
  final int nights;
  final Function(int) onNightsChanged;

  const CustomDateRangeSelector({
    super.key,
    required this.dateRange,
    required this.onDateRangeChanged,
    required this.nights,
    required this.onNightsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row with Check-in and Nights Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Check-in Date Section
              GestureDetector(
                onTap: () async {
                  final result = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange: dateRange,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: TColor.primary,
                            onPrimary: TColor.white,
                            surface: TColor.white,
                            onSurface: TColor.primaryText,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (result != null) {
                    onDateRangeChanged(result);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TColor.primary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Check-in',
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: TColor.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${dateRange.start.day}/${dateRange.start.month}/${dateRange.start.year}',
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Nights Selector Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: TColor.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: TColor.primary, size: 18),
                      onPressed: () {
                        if (nights > 1) onNightsChanged(nights - 1);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      '$nights Nights',
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: TColor.primary, size: 18),
                      onPressed: () => onNightsChanged(nights + 1),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Check-out Date Display Section
          Text(
            'Check-out: ${dateRange.end.day}/${dateRange.end.month}/${dateRange.end.year}',
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
