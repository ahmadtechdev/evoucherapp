import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';

class DailyActivityReport extends StatefulWidget {
  const DailyActivityReport({super.key});

  @override
  DailyActivityReportState createState() => DailyActivityReportState();
}

class DailyActivityReportState extends State<DailyActivityReport> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  // Dummy data
  final List<Map<String, dynamic>> activities = [
    {
      'voucherNo': 'CV 877',
      'date': DateTime.now(),
      'account': 'Afaq Travels',
      'description': 'TEST',
      'debit': 25.00,
      'credit': 0.00,
    },
    {
      'voucherNo': 'CV 877',
      'date': DateTime.now(),
      'account': 'Cash',
      'description': 'TEST',
      'debit': 0.00,
      'credit': 25.00,
    },
    // Add more dummy data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Activity Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: DateSelector2(
                              label: "From: ",
                              fontSize: 12,
                              initialDate: fromDate,
                              onDateChanged: (date) {})),
                      const SizedBox(width: 16),
                      Expanded(
                          child: DateSelector2(
                              label: "  To: ",
                              fontSize: 12,
                              initialDate: toDate,
                              onDateChanged: (date) {})),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Submit'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.print),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'From ${DateFormat('E, dd MMM yyyy').format(fromDate)} To ${DateFormat('E, dd MMM yyyy').format(toDate)}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      border: Border.all(
                        color: TColor.primary.withOpacity(0.2),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  activity['voucherNo'],
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(activity['date']),
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['account'],
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:TColor.third.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Debit',
                                          style: TextStyle(
                                              color: TColor.secondaryText),
                                        ),
                                        Text(
                                          'Rs ${activity['debit'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: TColor.third,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:TColor.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Credit',
                                          style:
                                          TextStyle(color: TColor.secondaryText),
                                        ),
                                        Text(
                                          'Rs ${activity['credit'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: TColor.secondary,
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
                          const SizedBox(height: 4),
                          Text(
                            activity['description'],
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
