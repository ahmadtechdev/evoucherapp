import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../finance.dart';
import '../widgets/voucher_header.dart';
import '../widgets/voucher_widgets.dart';

class UnPostedCVoucher extends StatefulWidget {
  const UnPostedCVoucher({super.key});

  @override
  State<UnPostedCVoucher> createState() => _UnPostedCVoucherState();
}

class _UnPostedCVoucherState extends State<UnPostedCVoucher> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVouchers = [];
  final List<Map<String, dynamic>> _vouchers = [
    {
      'id': 'JV 862',
      'date': 'Thu, 14 Nov 2024',
      'description': 'DISCOUNT - CASH - W/O ENTRY FOR ACCOUNT ADJUSTMENT',
      'entries': '2',
      'addedBy': 'Muhammad Ali',
    },
    {
      'id': 'PV 445',
      'date': 'Wed, 13 Nov 2024',
      'description': 'PAYMENT VOUCHER - UTILITY BILLS SETTLEMENT',
      'entries': '3',
      'addedBy': 'Sarah Khan',
    },
    {
      'id': 'RV 723',
      'date': 'Mon, 11 Nov 2024',
      'description': 'RECEIPT - CUSTOMER ADVANCE PAYMENT',
      'entries': '1',
      'addedBy': 'Ahmed Hassan',
    },
    {
      'id': 'JV 863',
      'date': 'Sun, 10 Nov 2024',
      'description': 'SALARY ADJUSTMENT ENTRY - ACCOUNTING DEPARTMENT',
      'entries': '4',
      'addedBy': 'Fatima Zaidi',
    },
    {
      'id': 'CV 291',
      'date': 'Fri, 08 Nov 2024',
      'description': 'CASH PAYMENT - OFFICE SUPPLIES PURCHASE',
      'entries': '2',
      'addedBy': 'Omar Malik',
    },
    {
      'id': 'BV 556',
      'date': 'Thu, 07 Nov 2024',
      'description': 'BANK CHARGES ADJUSTMENT - MONTHLY STATEMENT',
      'entries': '1',
      'addedBy': 'Zainab Ahmed',
    },
    {
      'id': 'JV 864',
      'date': 'Wed, 06 Nov 2024',
      'description': 'DEPRECIATION ENTRY - FIXED ASSETS',
      'entries': '5',
      'addedBy': 'Imran Qureshi',
    },
    {
      'id': 'PV 446',
      'date': 'Tue, 05 Nov 2024',
      'description': 'VENDOR PAYMENT - MAINTENANCE SERVICES',
      'entries': '2',
      'addedBy': 'Ayesha Siddiqui',
    },
    {
      'id': 'RV 724',
      'date': 'Mon, 04 Nov 2024',
      'description': 'SALES REVENUE - CASH RECEIPT',
      'entries': '3',
      'addedBy': 'Usman Malik',
    },
    {
      'id': 'CV 292',
      'date': 'Sun, 03 Nov 2024',
      'description': 'PETTY CASH REIMBURSEMENT',
      'entries': '6',
      'addedBy': 'Nadia Hussain',
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
          .where((voucher) => voucher['addedBy']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                  VoucherHeader(
                    title: 'Cash Vouchers List',
                    selectedDate: selectedDate,
                    onFromDateChanged: (newDate) {
                      setState(() => selectedDate = newDate);
                    },
                    onToDateChanged: (newDate) {
                      setState(() => selectedDate = newDate);
                    },
                    searchController: _searchController,
                    onSearchChanged: _filterVouchers,
                  ),
                  UnPostedVoucherListView(vouchers: _filteredVouchers),
                ],
              ))),
    );
  }
}
