import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:evoucher/views/finance_voucher/finance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';

class JournalViewVoucher extends StatefulWidget {
  const JournalViewVoucher({super.key});

  @override
  State<JournalViewVoucher> createState() => _JournalViewVoucherState();
}

class _JournalViewVoucherState extends State<JournalViewVoucher> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVouchers = [];

  // Dummy data
  final List<Map<String, dynamic>> _vouchers = [
    {
      'id': 'JV 849',
      'date': 'Wed, 30 Oct 2024',
      'description': 'DISCOUNT - CASH - W/O ENTRY FOR ACCOUNT ADJUSTMENT',
      'entries': 2,
      'addedBy': 'Umer Liaqat',
      'amount': 'PKR 1,720,079.00',
    },
    {
      'id': 'JV 847',
      'date': 'Wed, 23 Oct 2024',
      'description':
          'DISCOUNT - ALFLAH BANK - W/O ENTRY FOR ACCOUNT ADJUSTMENT',
      'entries': 2,
      'addedBy': 'Umer Liaqat',
      'amount': 'PKR 549,891.00',
    },
    {
      'id': 'JV 815',
      'date': 'Fri, 20 Sep 2024',
      'description': 'HUSSNAIN ALI - PAYMENT',
      'entries': 2,
      'addedBy': 'Muhammad Zain Sajid\nPosted by:Umer Liaqat',
      'amount': 'PKR 2.00',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredVouchers = _vouchers;
  }

  void _filterVouchers(String query) {
    setState(() {
      _filteredVouchers = _vouchers
          .where((voucher) => voucher['description']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        Get.off(() => const Finance());
                      },
                      child: const Icon(Icons.arrow_back)),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: TColor.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateSelector(
                      fontSize: 16,
                      initialDate: selectedDate,
                      label: "From Month:",
                      onDateChanged: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DateSelector(
                      fontSize: 16,
                      initialDate: selectedDate,
                      label: "To Month:    ",
                      onDateChanged: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'JOURNAL VOUCHERS LIST',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FROM: WED, 08-JAN-2020 | TO: WED, 13-NOV-2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: TColor.third,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: _filterVouchers,
                      decoration: InputDecoration(
                        hintText: 'Search by description...',
                        hintStyle: TextStyle(color: TColor.placeholder),
                        filled: true,
                        fillColor: TColor.textfield,
                        prefixIcon:
                            Icon(Icons.search, color: TColor.placeholder),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Voucher Cards List
              ListView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                // Allows ListView to take up only as much space as needed
                physics: const NeverScrollableScrollPhysics(),
                // Disable internal scrolling
                itemCount: _filteredVouchers.length,
                itemBuilder: (context, index) {
                  final voucher = _filteredVouchers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      border: Border.all(
                        color: TColor.primary.withOpacity(0.2),
                        // Set your desired border color here
                        width: 1.0, // Adjust the border width as needed
                      ),
                      borderRadius: BorderRadius.circular(
                          12), // Match the Card's border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                voucher['id'],
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                voucher['date'],
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Description
                          Text(
                            voucher['description'],
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Footer Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Added by: ${voucher['addedBy']}',
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Entries: ${voucher['entries']}',
                                    style: TextStyle(
                                      color: TColor.secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                voucher['amount'],
                                style: TextStyle(
                                  color: TColor.fourth,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Action Buttons
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.visibility),
                                label: const Text('View'),
                                style: TextButton.styleFrom(
                                  foregroundColor: TColor.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.print),
                                label: const Text('Print'),
                                style: TextButton.styleFrom(
                                  foregroundColor: TColor.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  ;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
