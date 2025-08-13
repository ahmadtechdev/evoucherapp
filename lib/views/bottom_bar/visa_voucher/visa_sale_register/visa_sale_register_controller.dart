import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../service/api_service.dart';

class VisaSaleRegisterController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables for date range
  final Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> toDate = DateTime.now().obs;

  // Observables for visa data
  final RxList<dynamic> dailyRecords = <dynamic>[].obs;
  final RxList<dynamic> filteredDailyRecords = <dynamic>[].obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Search functionality
  final RxString searchQuery = ''.obs;

  // Total summary with default values
  final Rx<Map<String, dynamic>> totalSummary = Rx<Map<String, dynamic>>({
    'total_count': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit': '0.00'
  });

  // Filtered total summary
  final Rx<Map<String, dynamic>> filteredTotalSummary = Rx<Map<String, dynamic>>({
    'total_count': 0,
    'total_buying': '0.00',
    'total_selling': '0.00',
    'total_profit': '0.00'
  });

  @override
  void onInit() {
    super.onInit();
    fetchVisaSaleRegisterData();
  }

  Future<void> fetchVisaSaleRegisterData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate.value);
      final String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate.value);

      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'visaSaleRegister',
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

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
      errorMessage.value = e.toString();
    } finally {
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
        if (dailyRecord['entries'] != null) {
          List<dynamic> filteredEntries = [];
          
          for (var entry in dailyRecord['entries']) {
            if (_matchesSearchCriteria(entry, query)) {
              filteredEntries.add(entry);
            }
          }

          if (filteredEntries.isNotEmpty) {
            // Create a new daily record with filtered entries
            var filteredDailyRecord = Map<String, dynamic>.from(dailyRecord);
            filteredDailyRecord['entries'] = filteredEntries;
            
            // Calculate daily totals for filtered entries
            filteredDailyRecord['totals'] = _calculateDailyTotals(filteredEntries);
            
            filtered.add(filteredDailyRecord);
          }
        }
      }

      filteredDailyRecords.value = filtered;
      _calculateFilteredTotalSummary(filtered);
    }
  }

  // Check if a visa entry matches the search criteria
  bool _matchesSearchCriteria(dynamic entry, String query) {
    // Search in visa number (v_number)
    final vNumber = (entry['v_number'] ?? '').toString().toLowerCase();
    if (vNumber.contains(query)) return true;

    // Search in visa number
    final visaNumber = (entry['visa_number'] ?? '').toString().toLowerCase();
    if (visaNumber.contains(query)) return true;

    // Search in customer name
    final customer = (entry['customer'] ?? '').toString().toLowerCase();
    if (customer.contains(query)) return true;

    // Search in account
    final account = (entry['account'] ?? '').toString().toLowerCase();
    if (account.contains(query)) return true;

    // Search in visa type
    final visaType = (entry['visa_type'] ?? '').toString().toLowerCase();
    if (visaType.contains(query)) return true;

    // Search in country
    final country = (entry['country'] ?? '').toString().toLowerCase();
    if (country.contains(query)) return true;

    // Search in supplier
    final supplier = (entry['supplier'] ?? '').toString().toLowerCase();
    if (supplier.contains(query)) return true;

    return false;
  }

  // Calculate daily totals for a list of visa entries
  Map<String, dynamic> _calculateDailyTotals(List<dynamic> entries) {
    int totalCount = entries.length;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfit = 0;

    for (var entry in entries) {
      totalBuying += entry['buying'] ?? 0;
      totalSelling += entry['selling'] ?? 0;
      totalProfit += entry['profit_loss'] ?? 0;
    }

    return {
      'count': totalCount,
      'buying': NumberFormat('#,##0.00').format(totalBuying),
      'selling': NumberFormat('#,##0.00').format(totalSelling),
      'profit': NumberFormat('#,##0.00').format(totalProfit),
    };
  }

  void _calculateTotalSummary(List<dynamic> records) {
    int totalCount = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfit = 0;

    for (var dailyRecord in records) {
      if (dailyRecord['entries'] != null) {
        final entries = dailyRecord['entries'] as List;
        totalCount += entries.length;

        for (var entry in entries) {
          totalBuying += entry['buying'] ?? 0;
          totalSelling += entry['selling'] ?? 0;
          totalProfit += entry['profit_loss'] ?? 0;
        }
      }
    }

    totalSummary.value = {
      'total_count': totalCount,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit': NumberFormat('#,##0.00').format(totalProfit)
    };
  }

  // Calculate filtered total summary
  void _calculateFilteredTotalSummary(List<dynamic> filteredRecords) {
    int totalCount = 0;
    double totalBuying = 0;
    double totalSelling = 0;
    double totalProfit = 0;

    for (var dailyRecord in filteredRecords) {
      if (dailyRecord['entries'] != null) {
        final entries = dailyRecord['entries'] as List;
        totalCount += entries.length;

        for (var entry in entries) {
          totalBuying += entry['buying'] ?? 0;
          totalSelling += entry['selling'] ?? 0;
          totalProfit += entry['profit_loss'] ?? 0;
        }
      }
    }

    // Update filtered total summary
    filteredTotalSummary.value = {
      'total_count': totalCount,
      'total_buying': NumberFormat('#,##0.00').format(totalBuying),
      'total_selling': NumberFormat('#,##0.00').format(totalSelling),
      'total_profit': NumberFormat('#,##0.00').format(totalProfit)
    };
  }

  void updateDateRange(DateTime start, DateTime end) {
    fromDate.value = start;
    toDate.value = end;
    fetchVisaSaleRegisterData();
  }
}