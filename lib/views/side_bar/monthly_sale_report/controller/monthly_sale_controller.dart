import 'package:evoucher/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/monthly_sales_data.dart';

class MonthlySalesController extends GetxController {
  final fromDate = DateTime(2023, 12).obs;
  final toDate = DateTime(2024, 12).obs;
  final RxList<DateTime> months = <DateTime>[].obs;
  final RxMap<String, MonthlySalesModel> salesData =
      <String, MonthlySalesModel>{}.obs;
  final RxBool isLoading = false.obs;
  final apiService = Get.put(ApiService());

  // Observable for totals
  final Rx<MonthlySalesModel> totalSales = MonthlySalesModel(
    ticketSales: 0,
    hotelBookings: 0,
    visaServices: 0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    fromDate.value = DateTime(now.year, now.month, 1);
    toDate.value = DateTime(now.year, now.month, 1);
    updateMonths();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      isLoading.value = true;

      // Format dates for API request
      String fromDateStr = DateFormat('yyyy-MM').format(fromDate.value);
      String toDateStr = DateFormat('yyyy-MM').format(toDate.value);

      final response =
          await apiService.fetchDateRangeReport(endpoint: 'monthlySaleReport', fromDate: fromDateStr, toDate: toDateStr);

      if (response != null && response['status'] == 'success') {
        // Clear existing data
        salesData.clear();

        // Process ticket vouchers
        for (var ticket in response['data']['ticket_vouchers']) {
          String monthStr = ticket['month'];
          DateTime monthDate = DateFormat('MMM yyyy').parse(monthStr);
          String key = '${monthDate.year}-${monthDate.month}';

          salesData[key] = MonthlySalesModel(
            ticketSales: ticket['amount'] as int,
            hotelBookings: 0, // Will be updated in next loop
            visaServices: 0, // Will be updated in next loop
          );
        }

        // Process hotel vouchers
        for (var hotel in response['data']['hotel_vouchers']) {
          String monthStr = hotel['month'];
          DateTime monthDate = DateFormat('MMM yyyy').parse(monthStr);
          String key = '${monthDate.year}-${monthDate.month}';

          if (salesData.containsKey(key)) {
            salesData[key] = MonthlySalesModel(
              ticketSales: salesData[key]!.ticketSales,
              hotelBookings: hotel['amount'] as int,
              visaServices: salesData[key]!.visaServices,
            );
          }
        }

        // Process visa vouchers
        for (var visa in response['data']['visa_vouchers']) {
          String monthStr = visa['month'];
          DateTime monthDate = DateFormat('MMM yyyy').parse(monthStr);
          String key = '${monthDate.year}-${monthDate.month}';

          if (salesData.containsKey(key)) {
            salesData[key] = MonthlySalesModel(
              ticketSales: salesData[key]!.ticketSales,
              hotelBookings: salesData[key]!.hotelBookings,
              visaServices: visa['amount'] as int,
            );
          }
        }

        // Update totals
        totalSales.value = MonthlySalesModel(
          ticketSales: response['data']['totals']['ticket'] as int,
          hotelBookings: response['data']['totals']['hotel'] as int,
          visaServices: response['data']['totals']['visa'] as int,
        );
      }
    } catch (e) {
      print('Error fetching sales data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch sales data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    updateMonths();
    fetchSalesData();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    updateMonths();
    fetchSalesData();
  }

  void updateMonths() {
    List<DateTime> monthsList = [];
    DateTime current = fromDate.value;

    while (current.isBefore(toDate.value) ||
        (current.month == toDate.value.month &&
            current.year == toDate.value.year)) {
      monthsList.add(current);
      current = DateTime(
        current.year + (current.month == 12 ? 1 : 0),
        current.month == 12 ? 1 : current.month + 1,
      );
    }
    months.value = monthsList;
  }

  String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  // Get sales data for a specific month
  MonthlySalesModel getSalesData(DateTime month) {
    final key = '${month.year}-${month.month}';
    return salesData[key] ??
        MonthlySalesModel(
          ticketSales: 0,
          hotelBookings: 0,
          visaServices: 0,
        );
  }

  String formatDate(DateTime date) => DateFormat('MMM yyyy').format(date);
}
