import 'package:evoucher/service/api_service.dart';
import 'package:evoucher/views/finance_voucher/finance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/voucher_header.dart';
import '../widgets/voucher_widgets.dart';

class JournalViewVoucher extends StatefulWidget {
  const JournalViewVoucher({super.key});

  @override
  State<JournalViewVoucher> createState() => _JournalViewVoucherState();
}

class _JournalViewVoucherState extends State<JournalViewVoucher> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVouchers = [];
  List<Map<String, dynamic>> _originalVouchers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchJournalVouchers();
  }

  Future<void> _fetchJournalVouchers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Format dates for API
      String fromDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      String toDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      final response = await _apiService.postLogin(
          endpoint: 'getVoucherPosted',
          body: {
            "fromDate": fromDate,
            "toDate": toDate,
            "voucher_id": "",
            "voucher_type": "jv"
          }
      );

      if (response['status'] == 'success' && response['data'] != null) {
        // Transform API data to match existing card structure
        List<Map<String, dynamic>> voucherList = response['data'].map<Map<String, dynamic>>((item) {
          var master = item['master'];
          return {
            'id': 'JV ${master['voucher_id']}',
            'date': DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(master['voucher_data'])),
            'description': _getVoucherDescription(item['details']),
            'entries': master['num_entries'],
            'addedBy': master['added_by'],
            'amount': 'PKR ${master['total_debit']}',
            'fullDetails': item // Store full details for later use
          };
        }).toList();

        setState(() {
          _originalVouchers = voucherList;
          _filteredVouchers = voucherList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No vouchers found';
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

  String _getVoucherDescription(List<dynamic> details) {
    // Get a meaningful description from the first detail entry
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
                // Header
                VoucherHeader(
                  title: 'JOURNAL VOUCHERS LIST',
                  selectedDate: selectedDate,
                  onFromDateChanged: (newDate) {
                    setState(() => selectedDate = newDate);
                    _fetchJournalVouchers();
                  },
                  onToDateChanged: (newDate) {
                    setState(() => selectedDate = newDate);
                    _fetchJournalVouchers();
                  },
                  searchController: _searchController,
                  onSearchChanged: _filterVouchers,
                ),

                // Loading or Error State
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty)
                  Center(child: Text(_errorMessage))
                else if (_filteredVouchers.isEmpty)
                    const Center(child: Text('No vouchers found'))
                  else
                    EntryVoucherListView(
                      vouchers: _filteredVouchers,
                      type: 'journal',
                      onVoucherTap: (voucher) {
                        // Print full voucher details when view is tapped
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