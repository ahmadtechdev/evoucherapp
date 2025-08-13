import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';

class HotelSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for booking data
  final RxList<dynamic> dailyRecords = <dynamic>[].obs;
  final RxList<dynamic> filteredDailyRecords = <dynamic>[].obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Search functionality
  final RxString searchQuery = ''.obs;

  // Total summary with default values
  final Rx<Map<String, dynamic>> totalSummary = Rx<Map<String, dynamic>>({
    'total_rows': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit_loss': '0.00'
  });

  // Filtered total summary
  final Rx<Map<String, dynamic>> filteredTotalSummary = Rx<Map<String, dynamic>>({
    'total_rows': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit_loss': '0.00'
  });

  @override
  void onInit() {
    super.onInit();
    // Fetch data when controller is initialized
    fetchHotelSaleRegisterData();
  }

  // Fetch hotel sale register data
  Future<void> fetchHotelSaleRegisterData() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = null;

      // Format dates for API
      final String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate.value);

      // Call API
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'hotelSaleRegister',
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      // Update data
      if (response['status'] == 'success') {
        dailyRecords.value = response['data']['daily_records'] ?? [];

        // Calculate and update totals
        _calculateTotalSummary(dailyRecords.value);
        
        // Apply current search filter
        _applySearchFilter();
      } else {
        errorMessage.value = 'Failed to fetch data';
      }
    } catch (e) {
      // Handle errors
      errorMessage.value = e.toString();
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Update search query and filter results
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applySearchFilter();
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    _applySearchFilter();
  }

  // Apply search filter to daily records
  void _applySearchFilter() {
    if (searchQuery.value.isEmpty) {
      // If no search query, show all records
      filteredDailyRecords.value = dailyRecords.value;
      filteredTotalSummary.value = totalSummary.value;
    } else {
      // Filter records based on search query
      final query = searchQuery.value.toLowerCase();
      List<dynamic> filtered = [];

      for (var dailyRecord in dailyRecords.value) {
        if (dailyRecord['tickets'] != null) {
          List<dynamic> filteredBookings = [];
          
          for (var booking in dailyRecord['tickets']) {
            if (_matchesSearchCriteria(booking, query)) {
              filteredBookings.add(booking);
            }
          }

          if (filteredBookings.isNotEmpty) {
            // Create a new daily record with filtered bookings
            var filteredDailyRecord = Map<String, dynamic>.from(dailyRecord);
            filteredDailyRecord['tickets'] = filteredBookings;
            
            // Calculate daily totals for filtered bookings
            filteredDailyRecord['totals'] = _calculateDailyTotals(filteredBookings);
            
            filtered.add(filteredDailyRecord);
          }
        }
      }

      filteredDailyRecords.value = filtered;
      _calculateFilteredTotalSummary(filtered);
    }
  }

  // Check if a booking matches the search criteria
  bool _matchesSearchCriteria(dynamic booking, String query) {
    // Search in voucher number/name
    final voucherNumber = (booking['voucher_number'] ?? '').toString().toLowerCase();
    if (voucherNumber.contains(query)) return true;

    // Search in voucher ID
    final voucherId = (booking['voucher_id'] ?? '').toString().toLowerCase();
    if (voucherId.contains(query)) return true;

    // Search in pax name
    final paxName = (booking['pax_name'] ?? '').toString().toLowerCase();
    if (paxName.contains(query)) return true;

    // Search in customer account
    final customerAccount = (booking['customer_account'] ?? '').toString().toLowerCase();
    if (customerAccount.contains(query)) return true;

    // Search in sector
    final sector = (booking['sector'] ?? '').toString().toLowerCase();
    if (sector.contains(query)) return true;

    // Search in supplier account
    final supplierAccount = (booking['supplier_account'] ?? '').toString().toLowerCase();
    if (supplierAccount.contains(query)) return true;

    // Search in confirmation number
    final confNumber = (booking['conf_number'] ?? '').toString().toLowerCase();
    if (confNumber.contains(query)) return true;

    // Search in check in date
    final checkIn = (booking['check_in'] ?? '').toString().toLowerCase();
    if (checkIn.contains(query)) return true;

    // Search in check out date
    final checkOut = (booking['check_out'] ?? '').toString().toLowerCase();
    if (checkOut.contains(query)) return true;

    return false;
  }

  // Calculate daily totals for a list of bookings
  Map<String, dynamic> _calculateDailyTotals(List<dynamic> bookings) {
    int totalRows = bookings.length;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfitLoss = 0;

    for (var booking in bookings) {
      // Parse buying amount
      final buyingAmount = double.tryParse(
              booking['buying_amount'].toString().replaceAll(',', '')) ??
          0;
      totalBuying += buyingAmount;

      // Parse selling amount
      final sellingAmount = double.tryParse(
              booking['selling_amount'].toString().replaceAll(',', '')) ??
          0;
      totalSelling += sellingAmount;

      // Parse profit/loss amount
      if (booking['profit_loss'] != null) {
        final profitLossAmount = double.tryParse(booking['profit_loss']
                    ['amount']
                .toString()
                .replaceAll(',', '')) ??
            0;
        totalProfitLoss += profitLossAmount;
      }
    }

    return {
      'total_rows': totalRows,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit_loss': NumberFormat('#,##0.00').format(totalProfitLoss),
    };
  }

  // Calculate total summary from daily records
  void _calculateTotalSummary(List<dynamic> records) {
    int totalRows = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfitLoss = 0;

    for (var dailyRecord in records) {
      if (dailyRecord['tickets'] != null) {
        final bookings = dailyRecord['tickets'] as List;
        totalRows += bookings.length;

        for (var booking in bookings) {
          // Parse buying amount
          final buyingAmount = double.tryParse(
                  booking['buying_amount'].toString().replaceAll(',', '')) ??
              0;
          totalBuying += buyingAmount;

          // Parse selling amount
          final sellingAmount = double.tryParse(
                  booking['selling_amount'].toString().replaceAll(',', '')) ??
              0;
          totalSelling += sellingAmount;

          // Parse profit/loss amount
          if (booking['profit_loss'] != null) {
            final profitLossAmount = double.tryParse(booking['profit_loss']
                        ['amount']
                    .toString()
                    .replaceAll(',', '')) ??
                0;
            totalProfitLoss += profitLossAmount;
          }
        }
      }
    }

    // Update total summary
    totalSummary.value = {
      'total_rows': totalRows,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit_loss': NumberFormat('#,##0.00').format(totalProfitLoss)
    };
  }

  // Calculate filtered total summary
  void _calculateFilteredTotalSummary(List<dynamic> filteredRecords) {
    int totalRows = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfitLoss = 0;

    for (var dailyRecord in filteredRecords) {
      if (dailyRecord['tickets'] != null) {
        final bookings = dailyRecord['tickets'] as List;
        totalRows += bookings.length;

        for (var booking in bookings) {
          // Parse buying amount
          final buyingAmount = double.tryParse(
                  booking['buying_amount'].toString().replaceAll(',', '')) ??
              0;
          totalBuying += buyingAmount;

          // Parse selling amount
          final sellingAmount = double.tryParse(
                  booking['selling_amount'].toString().replaceAll(',', '')) ??
              0;
          totalSelling += sellingAmount;

          // Parse profit/loss amount
          if (booking['profit_loss'] != null) {
            final profitLossAmount = double.tryParse(booking['profit_loss']
                        ['amount']
                    .toString()
                    .replaceAll(',', '')) ??
                0;
            totalProfitLoss += profitLossAmount;
          }
        }
      }
    }

    // Update filtered total summary
    filteredTotalSummary.value = {
      'total_rows': totalRows,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit_loss': NumberFormat('#,##0.00').format(totalProfitLoss)
    };
  }

  // Update date range and refresh data
  void updateDateRange(DateTime start, DateTime end) {
    fromDate.value = start;
    toDate.value = end;
    fetchHotelSaleRegisterData();
  }
}