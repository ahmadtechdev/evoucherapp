import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryHotelController extends GetxController {
  // Date Fields
  final Rx<DateTime> todayDate = DateTime.now().obs;
  final Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  ).obs;
  final Rx<DateTime?> cancellationDeadlineDate = Rx<DateTime?>(null);

  // Customer Fields
  final customerAccount = TextEditingController();
  final paxName = TextEditingController();
  final phoneNo = TextEditingController();
  final hotelName = TextEditingController();
  final country = TextEditingController();
  final city = TextEditingController();

  // Booking Details
  final RxInt nights = RxInt(1);
  final RxInt roomsCount = RxInt(1);
  final RxString roomType = RxString('');
  final RxString meal = RxString('');

  // Guest Count
  final RxInt adultsCount = RxInt(1);
  final RxInt childrenCount = RxInt(0);

  // Selling Side Calculations
  final roomPerNightSelling = TextEditingController();
  final RxDouble totalSellingAmount = RxDouble(0.0);
  final roeSellingRate = TextEditingController(text: '1');
  final RxDouble pkrTotalSelling = RxDouble(0.0);
  final RxString sellingCurrency = RxString('');

  // Buying Side Calculations
  final supplierDetail = TextEditingController();
  final supplierConfirmationNo = TextEditingController();
  final hotelConfirmationNo = TextEditingController();
  final consultantName = TextEditingController();
  final roomPerNightBuying = TextEditingController();
  final totalBuyingAmount = TextEditingController();
  final RxDouble pkrTotalBuying = RxDouble(0.0);
  final RxString buyingCurrency = RxString('');
  final roebuyingRate = TextEditingController(text: '1');

  // Summary
  final RxDouble profit = RxDouble(0.0);
  final RxDouble loss = RxDouble(0.0);

  void updateDateRange(DateTimeRange newRange) {
    dateRange.value = newRange;
    nights.value = newRange.duration.inDays;
    calculateAll();
  }

  void updateNights(int newNights) {
    if (newNights > 0) {
      nights.value = newNights;
      dateRange.value = DateTimeRange(
        start: dateRange.value.start,
        end: dateRange.value.start.add(Duration(days: newNights)),
      );
      calculateAll();
    }
  }

  void incrementNights() {
    updateNights(nights.value + 1);
  }

  void decrementNights() {
    if (nights.value > 1) {
      updateNights(nights.value - 1);
    }
  }

  // Enhanced calculation methods
  void calculateCustomerSide({bool fromTotal = false}) {
    try {
      final rooms = roomsCount.value > 0 ? roomsCount.value : 1;
      final roeRate = double.tryParse(roeSellingRate.text) ?? 1.0;

      if (fromTotal) {
        final totalSelling =
            double.tryParse(totalSellingAmount.value.toString()) ?? 0.0;
        roomPerNightSelling.text = (totalSelling / rooms).toStringAsFixed(2);
      } else {
        final perNightSelling =
            double.tryParse(roomPerNightSelling.text) ?? 0.0;
        totalSellingAmount.value = rooms * perNightSelling;
      }

      pkrTotalSelling.value = totalSellingAmount.value * roeRate;
      calculateSummary();
    } catch (e) {
      debugPrint('Error in calculateCustomerSide: $e');
    }
  }

  void calculateSupplierSide({bool fromTotal = false}) {
    try {
      final rooms = roomsCount.value > 0 ? roomsCount.value : 1;
      final nightCount = nights.value > 0 ? nights.value : 1;
      final roeRate = double.tryParse(roebuyingRate.text) ?? 1.0;

      if (fromTotal) {
        final totalBuying = double.tryParse(totalBuyingAmount.text) ?? 0;
        roomPerNightBuying.text =
            (totalBuying / (nightCount * rooms)).toStringAsFixed(2);
      } else {
        final perNightBuying = double.tryParse(roomPerNightBuying.text) ?? 0.0;
        totalBuyingAmount.text =
            (perNightBuying * nightCount * rooms).toStringAsFixed(2);
      }

      pkrTotalBuying.value = double.tryParse(totalBuyingAmount.text)! * roeRate;
      calculateSummary();
    } catch (e) {
      debugPrint('Error in calculateSupplierSide: $e');
    }
  }

  void calculateSummary() {
    final pkrTotalBuyingValue = pkrTotalBuying.value;
    final totalSellingValue = pkrTotalSelling.value;

    if (totalSellingValue > pkrTotalBuyingValue) {
      profit.value = (totalSellingValue - pkrTotalBuyingValue).roundToDouble();
      loss.value = 0.0;
    } else if (pkrTotalBuyingValue > totalSellingValue) {
      loss.value = ((pkrTotalBuyingValue - totalSellingValue)*-1).roundToDouble();
      profit.value = 0.0;
    } else {
      profit.value = 0.0;
      loss.value = 0.0;
    }
  }

  void calculateAll() {
    calculateCustomerSide();
    calculateSupplierSide();
  }

  // Additional Details Management
  final RxBool isHotelReceivingAccountsEnabled = false.obs;
  final RxList<Map<String, dynamic>> hotelReceivingDetails =
      <Map<String, dynamic>>[].obs;

  void addHotelReceivingDetail() {
    hotelReceivingDetails.add({
      'name': ''.obs,
      'amount': ''.obs,
    });
  }

  void removeHotelReceivingDetail(int index) {
    if (hotelReceivingDetails.length > 1) {
      hotelReceivingDetails.removeAt(index);
    }
  }

}
