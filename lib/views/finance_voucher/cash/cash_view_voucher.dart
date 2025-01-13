import 'package:evoucher/service/api_service.dart';
import 'package:evoucher/views/finance_voucher/finance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/voucher_header.dart';
import '../widgets/voucher_widgets.dart';

class CashViewVoucher extends StatefulWidget {
  const CashViewVoucher({super.key});

  @override
  State<CashViewVoucher> createState() => _CashViewVoucherState();
}

class _CashViewVoucherState extends State<CashViewVoucher> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVouchers = [];
  List<Map<String, dynamic>> _originalVouchers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
          fromDate = DateTime(DateTime.now().year, DateTime.now().month);
// Set to 180 days before
    _fetchJournalVouchers();
  }

  bool validateDateRange() {
    if (toDate.isBefore(fromDate)) {
      setState(() {
        _errorMessage = 'To date cannot be before from date';
        _isLoading = false;
      });
      return false;
    }
    return true;
  }

  Future<void> _fetchJournalVouchers() async {
    if (!validateDateRange()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Format dates for API

      String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

      final response =
          await _apiService.postLogin(endpoint: 'getVoucherPosted', body: {
        "fromDate": formattedFromDate,
        "toDate": formattedToDate,
        "voucher_id": "",
        "voucher_type": "cv"
      });

      if (response['status'] == 'success' && response['data'] != null) {
        List<Map<String, dynamic>> voucherList =
            response['data'].map<Map<String, dynamic>>((item) {
          var master = item['master'];
          return {
            'id': 'JV ${master['voucher_id']}',
            'date': DateFormat('EEE, dd MMM yyyy')
                .format(DateTime.parse(master['voucher_data'])),
            'description': _getVoucherDescription(item['details']),
            'entries': master['num_entries'],
            'addedBy': master['added_by'],
            'amount': 'PKR ${master['total_debit']}',
            'fullDetails': item
          };
        }).toList();

        setState(() {
          _originalVouchers = voucherList;
          _filteredVouchers = voucherList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No vouchers found for the selected date range';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching vouchers: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void handleFromDateChanged(DateTime newDate) {
    setState(() {
      fromDate = newDate;
      _errorMessage = '';
    });
    _fetchJournalVouchers();
  }

  void handleToDateChanged(DateTime newDate) {
    setState(() {
      toDate = newDate;
      _errorMessage = '';
    });
    _fetchJournalVouchers();
  }

  String _getVoucherDescription(List<dynamic> details) {
    return details.isNotEmpty
        ? details[0]['description']
        : 'No description available';
  }

  void _filterVouchers(String query) {
    setState(() {
      _filteredVouchers = _originalVouchers
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
        child: RefreshIndicator(
          onRefresh: _fetchJournalVouchers,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  title: 'CASH VOUCHERS LIST',
                  selectedDate: fromDate, // For backwards compatibility
                  onFromDateChanged: handleFromDateChanged,
                  onToDateChanged: handleToDateChanged,
                  searchController: _searchController,
                  onSearchChanged: _filterVouchers,
                  fromDate: fromDate, // Add these new parameters
                  toDate: toDate,
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_filteredVouchers.isEmpty && _errorMessage.isEmpty)
                  const Center(child: Text('No vouchers found'))
                else
                  EntryVoucherListView(
                    vouchers: _filteredVouchers,
                    type: 'journal',
                    onVoucherTap: (voucher) {
                      print('Voucher Details: ${voucher['fullDetails']}');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
