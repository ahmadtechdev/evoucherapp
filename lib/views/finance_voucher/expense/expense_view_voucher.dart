import 'package:evoucher/views/finance_voucher/finance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../voucher_header.dart';
import '../voucher_widgets.dart';

class ExpenseViewVoucher extends StatefulWidget {
  const ExpenseViewVoucher({super.key});

  @override
  State<ExpenseViewVoucher> createState() => _ExpenseViewVoucherState();
}

class _ExpenseViewVoucherState extends State<ExpenseViewVoucher> {
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
              VoucherHeader(
                title: 'EXPENSE VOUCHERS LIST',
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
              EntryVoucherListView(vouchers: _filteredVouchers, type: 'expense',),
            ],
          ),
        ),
      ),
    );
  }
}
