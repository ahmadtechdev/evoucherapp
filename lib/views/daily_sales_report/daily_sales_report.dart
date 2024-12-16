import 'package:evoucher/views/daily_sales_report/day_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';

// Utility class for calculations
class SalesReportUtils {
  static List<Map<String, dynamic>> filterData(
      List<Map<String, dynamic>> salesData, DateTimeRange? dateRange) {
    if (dateRange == null) return salesData;
    return salesData.where((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(dateRange.end.add(const Duration(days: 1)));
    }).toList();
  }

  static int calculateTotal(List<Map<String, dynamic>> data, String key) {
    return data.fold<int>(
        0, (sum, entry) => sum + (entry['summary'][key] as int));
  }
}

class DailySalesReportScreen extends StatefulWidget {
  const DailySalesReportScreen({super.key});

  @override
  State<DailySalesReportScreen> createState() => _DailySalesReportScreenState();
}

class _DailySalesReportScreenState extends State<DailySalesReportScreen> {
  final List<Map<String, dynamic>> salesData = [
    // Sample data
    {
      "date": "2024-12-01",
      "summary": {"vNo": "V123", "totalP": 1200, "totalS": 24000, "pL": 2000},
      "details": {
        "vDate": "2024-12-01",
        "cAccount": "Account 1",
        "sAccount": "Account 2",
        "paxName": "John Doe"
      },
    },
    {
      "date": "2024-12-03",
      "summary": {"vNo": "V124", "totalP": 8000, "totalS": 16000, "pL": 1500},
      "details": {
        "vDate": "2024-12-03",
        "cAccount": "Account 3",
        "sAccount": "Account 4",
        "paxName": "Alice"
      },
    },
    // Add more sample data as needed
    // June 2024
    {
      "date": "2024-11-01",
      "summary": {"vNo": "V201", "totalP": 1500, "totalS": 2000, "pL": 500},
      "details": {
        "vDate": "2024-06-01",
        "cAccount": "Account A",
        "sAccount": "Account B",
        "paxName": "John Smith",
      },
    },
    {
      "date": "2024-11-04",
      "summary": {"vNo": "V202", "totalP": 3000, "totalS": 2500, "pL": -500},
      "details": {
        "vDate": "2024-06-04",
        "cAccount": "Account C",
        "sAccount": "Account D",
        "paxName": "Alice Johnson",
      },
    },
    {
      "date": "2024-11-08",
      "summary": {"vNo": "V203", "totalP": 2500, "totalS": 3500, "pL": 1000},
      "details": {
        "vDate": "2024-06-08",
        "cAccount": "Account E",
        "sAccount": "Account F",
        "paxName": "Bob Brown",
      },
    },
    // Add 7 more entries for June here
    // July 2024
    {
      "date": "2024-10-02",
      "summary": {"vNo": "V204", "totalP": 4000, "totalS": 5000, "pL": 1000},
      "details": {
        "vDate": "2024-07-02",
        "cAccount": "Account G",
        "sAccount": "Account H",
        "paxName": "Chris Evans",
      },
    },
    {
      "date": "2024-10-10",
      "summary": {"vNo": "V205", "totalP": 2000, "totalS": 1500, "pL": -500},
      "details": {
        "vDate": "2024-07-10",
        "cAccount": "Account I",
        "sAccount": "Account J",
        "paxName": "Diana Prince",
      },
    },
    {
      "date": "2024-10-15",
      "summary": {"vNo": "V206", "totalP": 5000, "totalS": 7000, "pL": 2000},
      "details": {
        "vDate": "2024-07-15",
        "cAccount": "Account K",
        "sAccount": "Account L",
        "paxName": "Edward Stone",
      },
    },
  ];

  DateTimeRange? selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 15)),
    end: DateTime.now(),
  );

  void _updateDateRange({DateTime? start, DateTime? end}) {
    setState(() {
      selectedDateRange = DateTimeRange(
        start: start ?? selectedDateRange!.start,
        end: end ?? selectedDateRange!.end,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredData =
    SalesReportUtils.filterData(salesData, selectedDateRange);

    return Scaffold(
      backgroundColor: TColor.textfield,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Sales Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 9),
      body: Column(
        children: [
          _DateSelectionSection(
            selectedDateRange: selectedDateRange,
            onDateChanged: _updateDateRange,
          ),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(
              child: Text("No data available for the selected range."),
            )
                : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryCard(data: filteredData),
                const SizedBox(height: 16),
                ...filteredData.asMap().entries.map(
                      (entry) => DayCard(
                    index: entry.key,
                    dayData: entry.value,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Widget: Summary Card
class _SummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final totalPurchase = SalesReportUtils.calculateTotal(data, 'totalP');
    final totalSales = SalesReportUtils.calculateTotal(data, 'totalS');
    final totalProfit = SalesReportUtils.calculateTotal(data, 'pL');

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
            'Total Entries: ${data.length}',
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

// Widget: Summary Item
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


// Widget: Date Selection Section
class _DateSelectionSection extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final Function({DateTime? start, DateTime? end}) onDateChanged;

  const _DateSelectionSection({
    required this.selectedDateRange,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: TColor.secondary,
          //     minimumSize: const Size(double.infinity, 45),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text(
          //     'Generate Report',
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
          Text(
            selectedDateRange == null
                ? 'No date range selected'
                : 'From ${DateFormat('E, dd MMM yyyy').format(selectedDateRange!.start)} To ${DateFormat('E, dd MMM yyyy').format(selectedDateRange!.end)}',
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
