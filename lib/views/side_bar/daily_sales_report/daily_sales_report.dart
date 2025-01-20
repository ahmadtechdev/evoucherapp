import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/daily_sales_report_controller.dart';
import 'day_card_widget.dart';
import 'models/daily_sales_report_model.dart';

// Utility class for calculations

class DailySalesReportScreen extends StatefulWidget {
  const DailySalesReportScreen({super.key});

  @override
  State<DailySalesReportScreen> createState() => _DailySalesReportScreenState();
}

class _DailySalesReportScreenState extends State<DailySalesReportScreen> {
  final DailySalesReportController controller =
      Get.put(DailySalesReportController());
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      await controller
          .fetchDailySalesReport(controller.selectedDateRange.value);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _updateDateRange({DateTime? start, DateTime? end}) {
    controller.updateDateRange(DateTimeRange(
      start: start ?? controller.selectedDateRange.value.start,
      end: end ?? controller.selectedDateRange.value.end,
    ));
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Sales Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 9),
      body: Column(
        children: [
          Obx(() => _DateSelectionSection(
                selectedDateRange: controller.selectedDateRange.value,
                onDateChanged: _updateDateRange,
              )),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text(error!))
                    : Obx(() => controller.salesData.isEmpty
                        ? const Center(
                            child: Text(
                                "No data available for the selected range."),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _SummaryCard(salesData: controller.salesData),
                              const SizedBox(height: 16),
                              ...controller.salesData.asMap().entries.map(
                                    (entry) => DayCard(
                                      index: entry.key,
                                      dayData: entry.value.toJson(),
                                    ),
                                  ),
                            ],
                          )),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final RxList<SaleEntry> salesData;

  const _SummaryCard({required this.salesData});

  @override
  Widget build(BuildContext context) {
    final totalPurchase = salesData.fold<int>(
        0, (sum, entry) => sum + (entry.summary['totalP'] as int? ?? 0));
    final totalSales = salesData.fold<int>(
        0, (sum, entry) => sum + (entry.summary['totalS'] as int? ?? 0));
    final totalProfit = salesData.fold<int>(
        0, (sum, entry) => sum + (entry.summary['pL'] as int? ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Entries: ${salesData.length}',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _SummaryItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Purchases',
                value: 'Rs.${NumberFormat('#,###').format(totalPurchase)}',
              ),
              _SummaryItem(
                icon: Icons.attach_money,
                label: 'Sales',
                value: 'Rs.${NumberFormat('#,###').format(totalSales)}',
              ),
              _SummaryItem(
                icon: Icons.trending_up,
                label: 'P/L',
                value: 'Rs.${NumberFormat('#,###').format(totalProfit)}',
                valueColor: totalProfit > 0
                    ? TColor.secondary
                    : totalProfit < 0
                        ? TColor.third
                        : TColor.primaryText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: TColor.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? TColor.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Update the _DateSelectionSection widget
class _DateSelectionSection extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final Function({DateTime? start, DateTime? end}) onDateChanged;

  const _DateSelectionSection({
    required this.selectedDateRange,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailySalesReportController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateSelector2(
                  fontSize: 14,
                  label: 'From Date',
                  initialDate: selectedDateRange?.start ??
                      DateTime.now().subtract(const Duration(days: 30)),
                  onDateChanged: (date) => onDateChanged(start: date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DateSelector2(
                  fontSize: 14,
                  label: 'To Date',
                  initialDate: selectedDateRange?.end ?? DateTime.now(),
                  onDateChanged: (date) => onDateChanged(end: date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            selectedDateRange == null
                ? 'No date range selected'
                : 'From ${controller.formatDisplayDate(selectedDateRange!.start)} To ${controller.formatDisplayDate(selectedDateRange!.end)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
