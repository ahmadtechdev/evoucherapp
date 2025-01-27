import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../service/api_service.dart';
import '../finance.dart';
import '../widgets/voucher_header.dart';
import '../widgets/voucher_widgets.dart';

class UnPostedJVoucher extends StatefulWidget {
  const UnPostedJVoucher({super.key});

  @override
  State<UnPostedJVoucher> createState() => _UnPostedJVoucherState();
}

class _UnPostedJVoucherState extends State<UnPostedJVoucher> {
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
    _fetchUnpostedVouchers();
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

  Future<void> _fetchUnpostedVouchers() async {
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

      final response = await _apiService.fetchDateRangeReport(
          endpoint: "getVoucherUnPosted",
          fromDate: formattedFromDate,
          toDate: formattedToDate,
          additionalParams: {
            "voucher_id": "",
            "voucher_type": "jv",
          });

      if (response['status'] == 'success' &&
          response['data'] != null) {
        List<dynamic> data = response['data'] as List<dynamic>;
        List<Map<String, dynamic>> voucherList =
            data.map<Map<String, dynamic>>((item) {
          var master = item['master'];
          var details = item['details'] as List<dynamic>;
          return {
            'id': 'JV ${master['voucher_id']}',
            'date': DateFormat('EEE, dd MMM yyyy')
                .format(DateTime.parse(master['voucher_data'])),
            'description':
                details.isNotEmpty && details[0]['description'] != null
                    ? details[0]['description']
                    : 'No description available',
            'entries': master['num_entries'].toString(),
            'addedBy': master['added_by'] ?? 'Unknown',
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
          _errorMessage =
              'No unposted vouchers found for the selected date range';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching unposted vouchers: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void handleFromDateChanged(DateTime newDate) {
    setState(() {
      fromDate = newDate;
      _errorMessage = '';
    });
    _fetchUnpostedVouchers();
  }

  void handleToDateChanged(DateTime newDate) {
    setState(() {
      toDate = newDate;
      _errorMessage = '';
    });
    _fetchUnpostedVouchers();
  }

  void _filterVouchers(String query) {
    setState(() {
      _filteredVouchers = _originalVouchers
          .where((voucher) =>
              voucher['description']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              voucher['addedBy']
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
          onRefresh: _fetchUnpostedVouchers,
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
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                VoucherHeader(
                  title: 'UNPOSTED JOURNAL VOUCHERS',
                  selectedDate: fromDate,
                  onFromDateChanged: handleFromDateChanged,
                  onToDateChanged: handleToDateChanged,
                  searchController: _searchController,
                  onSearchChanged: _filterVouchers,
                  fromDate: fromDate,
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
                  const Center(child: Text('No unposted vouchers found'))
                else
                  UnPostedVoucherListView(
                    vouchers: _filteredVouchers,
                    onVoucherTap: (voucher) {
                      // print('Voucher Details: ${voucher['fullDetails']}');
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
