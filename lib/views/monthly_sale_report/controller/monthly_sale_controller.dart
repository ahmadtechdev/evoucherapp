// monthly_sales_controller.dart
import 'package:get/get.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'monthly_sales_data.dart';

class MonthlySalesController extends GetxController {
  final Rx<DateTime> fromDate = DateTime(2023, 12).obs;
  final Rx<DateTime> toDate = DateTime(2024, 12).obs;
  final RxList<DateTime> months = <DateTime>[].obs;
  final RxMap<String, MonthlySalesData> salesData = <String, MonthlySalesData>{}.obs;

  @override
  void onInit() {
    super.onInit();
    updateMonths();
  }


  // Method to generate or fetch sales data for a specific month
  MonthlySalesData getSalesData(DateTime month) {
    final key = '${month.year}-${month.month}';
    if (!salesData.containsKey(key)) {
      salesData[key] = MonthlySalesData(
        ticketSales: Random().nextInt(300000),
        hotelBookings: Random().nextInt(300000),
        visaServices: Random().nextInt(300000),
      );
    }
    return salesData[key]!;
  }

  // Method to get total sales data
  MonthlySalesData get totalSalesData {
    int totalTickets = 0;
    int totalHotels = 0;
    int totalVisas = 0;

    for (var data in salesData.values) {
      totalTickets += data.ticketSales;
      totalHotels += data.hotelBookings;
      totalVisas += data.visaServices;
    }

    return MonthlySalesData(
      ticketSales: totalTickets,
      hotelBookings: totalHotels,
      visaServices: totalVisas,
    );
  }


  void updateFromDate(DateTime date) {
    fromDate.value = date;
    updateMonths();
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    updateMonths();
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  String getDummyAmount() => (Random().nextInt(300000)).toString();

  String formatDate(DateTime date) => DateFormat('MMM yyyy').format(date);


}