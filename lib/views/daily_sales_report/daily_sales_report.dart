import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';

class DailySalesReportScreen extends StatefulWidget {
  const DailySalesReportScreen({super.key});

  @override
  State<DailySalesReportScreen> createState() => _DailySalesReportScreenState();
}

class _DailySalesReportScreenState extends State<DailySalesReportScreen> {
  // Sample data structure from DailySalesReportScreen
  final List<Map<String, dynamic>> salesData = [
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

  // Method to filter data based on date range
  List<Map<String, dynamic>> _filterData() {
    if (selectedDateRange == null) return salesData;

    return salesData.where((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isAfter(
              selectedDateRange!.start.subtract(const Duration(days: 1))) &&
          entryDate
              .isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  // Calculate total purchase
  int _calculateTotalPurchase(List<Map<String, dynamic>> data) {
    return data.fold<int>(
        0, (sum, entry) => sum + (entry['summary']['totalP'] as int));
  }

  // Calculate total sales
  int _calculateTotalSales(List<Map<String, dynamic>> data) {
    return data.fold<int>(
        0, (sum, entry) => sum + (entry['summary']['totalS'] as int));
  }

  // Calculate total profit/loss
  int _calculateTotalProfit(List<Map<String, dynamic>> data) {
    return data.fold<int>(
        0, (sum, entry) => sum + (entry['summary']['pL'] as int));
  }

  @override
  Widget build(BuildContext context) {
    // Filter data based on selected date range
    List<Map<String, dynamic>> filteredData = _filterData();

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
          _buildDateSelectionSection(),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(
                    child: Text("No data available for the selected range."))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildSummaryCard(filteredData),
                      const SizedBox(height: 16),
                      ...filteredData.asMap().entries.map(
                            (entry) => _buildDayCard(entry.key, entry.value),
                          ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionSection() {
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
                  onDateChanged: (date) => setState(() {
                    selectedDateRange = DateTimeRange(
                      start: date,
                      end: selectedDateRange?.end ?? DateTime.now(),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DateSelector2(
                  fontSize: 14,
                  label: 'To Date',
                  initialDate: selectedDateRange?.end ?? DateTime.now(),
                  onDateChanged: (date) => setState(() {
                    selectedDateRange = DateTimeRange(
                      start: selectedDateRange?.start ??
                          DateTime.now().subtract(const Duration(days: 30)),
                      end: date,
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondary,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Generate Report',
              style: TextStyle(color: Colors.white),
            ),
          ),
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

  Widget _buildSummaryCard(List<Map<String, dynamic>> data) {
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
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: TColor.primary.withOpacity(0.8),
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Purchases',
                      style: TextStyle(
                        color: TColor.secondaryText.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs.${NumberFormat('#,###').format(_calculateTotalPurchase(data))}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: TColor.primary.withOpacity(0.8),
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sales',
                      style: TextStyle(
                        color: TColor.secondaryText.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs.${NumberFormat('#,###').format(_calculateTotalSales(data))}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: TColor.primary.withOpacity(0.8),
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'P/L',
                      style: TextStyle(
                        color: TColor.secondaryText.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs.${NumberFormat('#,###').format(_calculateTotalProfit(data))}',
                      style: TextStyle(
                        color: _calculateTotalProfit(data) > 0
                            ? TColor.secondary
                            : _calculateTotalProfit(data) < 0
                                ? TColor.third
                                : TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(int index, Map<String, dynamic> dayData) {
    final summary = dayData['summary'];
    final details = dayData['details'];
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: TColor.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entry #${index + 1}',
                          style: TextStyle(
                            color: TColor.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, dd MMM yyyy')
                              .format(DateTime.parse(dayData['date'])),
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isExpanded ? 'Hide' : 'Detail',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'V#: ${summary['vNo']}',
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'V.Date: ${details['vDate']}',
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,)
                      ,
                      Text(
                        'Customer Account: ${details['cAccount']}',
                        style: TextStyle(
                          color: TColor.secondary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        // 'Pax Name: ${details['paxName']}',
                        'Supplier Account: ${details['sAccount']}',
                        style: TextStyle(
                          color: TColor.third,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pax Name: ${details['paxName']}',
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: TColor.primary,
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // 'V#: ${summary['vNo']}',
                      'Total Purchases:',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs.${NumberFormat('#,###').format(summary['totalP'])}',
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Sales',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs.${NumberFormat('#,###').format(summary['totalS'])}',
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profit/Loss',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs.${NumberFormat('#,###').format(summary['pL'])}',
                      style: TextStyle(
                        color:
                            summary['pL'] >= 0 ? TColor.secondary : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
