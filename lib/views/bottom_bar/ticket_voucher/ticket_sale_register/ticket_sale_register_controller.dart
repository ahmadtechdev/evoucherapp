import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';

class TicketSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate =
      DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for ticket data
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
    fetchTicketSaleRegisterData();
  }

  // Fetch ticket sale register data
  Future<void> fetchTicketSaleRegisterData() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = null;

      // Format dates for API
      final String formattedFromDate =
          DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate =
          DateFormat('yyyy-MM-dd').format(toDate.value);

      // Call API
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'ticketSaleRegister',
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
          List<dynamic> filteredTickets = [];
          
          for (var ticket in dailyRecord['tickets']) {
            if (_matchesSearchCriteria(ticket, query)) {
              filteredTickets.add(ticket);
            }
          }

          if (filteredTickets.isNotEmpty) {
            // Create a new daily record with filtered tickets
            var filteredDailyRecord = Map<String, dynamic>.from(dailyRecord);
            filteredDailyRecord['tickets'] = filteredTickets;
            
            // Calculate daily totals for filtered tickets
            filteredDailyRecord['totals'] = _calculateDailyTotals(filteredTickets);
            
            filtered.add(filteredDailyRecord);
          }
        }
      }

      filteredDailyRecords.value = filtered;
      _calculateFilteredTotalSummary(filtered);
    }
  }

  // Check if a ticket matches the search criteria
  bool _matchesSearchCriteria(dynamic ticket, String query) {
    // Search in voucher number/name
    final voucherNumber = (ticket['voucher_number'] ?? '').toString().toLowerCase();
    if (voucherNumber.contains(query)) return true;

    // Search in voucher ID
    final voucherId = (ticket['voucher_id'] ?? '').toString().toLowerCase();
    if (voucherId.contains(query)) return true;

    // Search in pax name (can be considered as voucher name)
    final paxName = (ticket['pax_name'] ?? '').toString().toLowerCase();
    if (paxName.contains(query)) return true;

    // Search in airline
    final airline = (ticket['airline'] ?? '').toString().toLowerCase();
    if (airline.contains(query)) return true;

    // Search in customer account
    final customerAccount = (ticket['customer_account'] ?? '').toString().toLowerCase();
    if (customerAccount.contains(query)) return true;

    // Search in PNR
    final pnr = (ticket['pnr'] ?? '').toString().toLowerCase();
    if (pnr.contains(query)) return true;

    return false;
  }

  // Calculate daily totals for a list of tickets
  Map<String, dynamic> _calculateDailyTotals(List<dynamic> tickets) {
    int totalRows = tickets.length;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfitLoss = 0;

    for (var ticket in tickets) {
      // Parse buying amount
      final buyingAmount = double.tryParse(
              ticket['buying_amount'].toString().replaceAll(',', '')) ??
          0;
      totalBuying += buyingAmount;

      // Parse selling amount
      final sellingAmount = double.tryParse(
              ticket['selling_amount'].toString().replaceAll(',', '')) ??
          0;
      totalSelling += sellingAmount;

      // Parse profit/loss amount
      if (ticket['profit_loss'] != null) {
        final profitLossAmount = double.tryParse(ticket['profit_loss']
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
        final tickets = dailyRecord['tickets'] as List;
        totalRows += tickets.length;

        for (var ticket in tickets) {
          // Parse buying amount
          final buyingAmount = double.tryParse(
                  ticket['buying_amount'].toString().replaceAll(',', '')) ??
              0;
          totalBuying += buyingAmount;

          // Parse selling amount
          final sellingAmount = double.tryParse(
                  ticket['selling_amount'].toString().replaceAll(',', '')) ??
              0;
          totalSelling += sellingAmount;

          // Parse profit/loss amount
          if (ticket['profit_loss'] != null) {
            final profitLossAmount = double.tryParse(ticket['profit_loss']
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
        final tickets = dailyRecord['tickets'] as List;
        totalRows += tickets.length;

        for (var ticket in tickets) {
          // Parse buying amount
          final buyingAmount = double.tryParse(
                  ticket['buying_amount'].toString().replaceAll(',', '')) ??
              0;
          totalBuying += buyingAmount;

          // Parse selling amount
          final sellingAmount = double.tryParse(
                  ticket['selling_amount'].toString().replaceAll(',', '')) ??
              0;
          totalSelling += sellingAmount;

          // Parse profit/loss amount
          if (ticket['profit_loss'] != null) {
            final profitLossAmount = double.tryParse(ticket['profit_loss']
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
    fetchTicketSaleRegisterData();
  }
}