import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:evoucher/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';

class DailyCashBook extends StatefulWidget {
  const DailyCashBook({super.key});

  @override
  _DailyCashBookState createState() => _DailyCashBookState();
}

class _DailyCashBookState extends State<DailyCashBook> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();

  // Dummy data
  final List<Map<String, dynamic>> transactions = [
    {
      'id': '877',
      'date': DateTime.now(),
      'description': 'Salary Payment',
      'receipt': 5000.00,
      'payment': 0.00,
      'balance': 44901.00,
    },
    {
      'id': '878',
      'date': DateTime.now(),
      'description': 'Office Supplies',
      'receipt': 0.00,
      'payment': 1500.00,
      'balance': 43401.00,
    },{
      'id': '878',
      'date': DateTime.now(),
      'description': 'Office Supplies',
      'receipt': 0.00,
      'payment': 1500.00,
      'balance': 43401.00,
    },{
      'id': '878',
      'date': DateTime.now(),
      'description': 'Office Supplies',
      'receipt': 0.00,
      'payment': 1500.00,
      'balance': 43401.00,
    },{
      'id': '878',
      'date': DateTime.now(),
      'description': 'Office Supplies',
      'receipt': 0.00,
      'payment': 1500.00,
      'balance': 43401.00,
    },
    // Add more dummy data as needed
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Cash Book'),
      ),
      drawer: const CustomDrawer(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.1),
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
                        child:DateSelector(
                          fontSize: screenHeight * 0.018, // Scaled font size
                          vpad: screenHeight * 0.01,    // Scaled vertical padding
                          initialDate: selectedDate,
                          label: "DATE:",
                          onDateChanged: (newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),    ),
                      const SizedBox(width: 12),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.file_download),
                        label: const Text('Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.secondary,
                          foregroundColor: TColor.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                        ),
                      ),


                    ],
                  ),
                  SearchTextField(hintText: "Search", onChange: (query) {
                    print(query);
                  }),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'V# ${transaction['id']}',
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(transaction['date']),
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            transaction['description'],
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receipt',
                                    style:
                                    TextStyle(color: TColor.secondaryText),
                                  ),
                                  Text(
                                    'Rs ${transaction['receipt'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: TColor.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment',
                                    style:
                                    TextStyle(color: TColor.secondaryText),
                                  ),
                                  Text(
                                    'Rs ${transaction['payment'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: TColor.third,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Balance',
                                    style:
                                    TextStyle(color: TColor.secondaryText),
                                  ),
                                  Text(
                                    'Rs ${transaction['balance'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalItem('Total Receipt', '6,500.00', TColor.secondary),
                  _buildTotalItem('Total Payment', '1,500.00', TColor.third),
                  _buildTotalItem('Closing Balance', '43,401.00', TColor.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalItem(String label, String amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rs $amount',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}