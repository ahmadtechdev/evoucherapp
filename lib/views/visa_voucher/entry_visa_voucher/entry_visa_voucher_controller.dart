import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisaVoucherControler extends GetxController {
  // Date Fields (unchanged)
  final Rx<DateTime> todayDate = DateTime.now().obs;
  final Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  ).obs;
  final Rx<DateTime?> cancellationDeadlineDate = Rx<DateTime?>(null);

  // Customer Fields (unchanged)
  final RxString customerAccount = RxString('');
  final RxString CustomerName = RxString('');
  final RxString phoneNo = RxString('');
  final RxString PassportNo = RxString('');
  final RxString country = RxString('');
  final RxString Visa_No = RxString('');
  final RxString Vtype = RxString('');

  // Booking Details (unchanged)
  final RxInt nights = RxInt(1);
  final RxInt roomsCount = RxInt(1);
  final RxString roomType = RxString('');
  final RxString meal = RxString('');

  // Guest Count (unchanged)
  final RxInt adultsCount = RxInt(1);
  final RxInt childrenCount = RxInt(0);

  // Selling Side Calculations (modified)
  final RxDouble Foreign_Sale_Rate = RxDouble(0.0);
  final RxDouble totalSellingAmount = RxDouble(0.0);
  final RxDouble roeSellingRate = RxDouble(1.0);
  final RxDouble pkrTotalSelling = RxDouble(0.0);
  final RxString sellingCurrency = RxString('');

  // Buying Side Calculations (modified)
  final RxString supplierDetail = RxString('');
  final RxString Foreign_Purchsae_Rate = RxString('');
  final RxString hotelConfirmationNo = RxString('');
  final RxString consultantName = RxString('');

  final RxDouble roomPerNightBuying = RxDouble(0.0);
  final RxDouble totalBuyingAmount = RxDouble(0.0);
  final RxDouble pkrTotalBuying = RxDouble(0.0);
  final RxString buyingCurrency = RxString('');

  // Summary (unchanged)
  final RxDouble profit = RxDouble(0.0);
  final RxDouble loss = RxDouble(0.0);
  final RxDouble totalDebit = RxDouble(0.0);
  final RxDouble totalCredit = RxDouble(0.0);

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
    // Ensure we don't divide by zero
    final rooms = roomsCount.value > 0 ? roomsCount.value : 1;
    final roeRate = roeSellingRate.value > 0 ? roeSellingRate.value : 1.0;

    if (fromTotal) {
      // Calculate room per night when total amount is entered
      Foreign_Sale_Rate.value = totalSellingAmount.value / rooms;
    } else {
      // Calculate total selling amount when room per night is entered
      totalSellingAmount.value = rooms * Foreign_Sale_Rate.value;
    }

    // Calculate PKR total selling
    pkrTotalSelling.value = totalSellingAmount.value * roeRate;

    calculateSummary();
  }

  void calculateSupplierSide({bool fromTotal = false}) {
    // Ensure we don't divide by zero
    final rooms = roomsCount.value > 0 ? roomsCount.value : 1;
    final nightCount = nights.value > 0 ? nights.value : 1;
    final roeRate = roeSellingRate.value > 0 ? roeSellingRate.value : 1.0;

    if (fromTotal) {
      // Calculate room per night when total buying amount is entered
      roomPerNightBuying.value = totalBuyingAmount.value / (nightCount * rooms);
    } else {
      // Calculate total buying amount when room per night is entered
      totalBuyingAmount.value = roomPerNightBuying.value * nightCount * rooms;
    }

    // Calculate PKR total buying
    pkrTotalBuying.value = totalBuyingAmount.value * roeRate;

    calculateSummary();
  }

  void calculateSummary() {
    // Calculate profit, loss, debit, and credit
    profit.value = pkrTotalBuying.value - pkrTotalSelling.value;
    loss.value = profit.value - totalSellingAmount.value;
    totalDebit.value = pkrTotalSelling.value;
    totalCredit.value = pkrTotalBuying.value + profit.value;
  }

  void calculateAll() {
    calculateCustomerSide();
    calculateSupplierSide();
  }

  // Add these to the HotelBookingController class
  final RxBool isAdditionalDetailsEnabled = false.obs;
  final RxList<Map<String, dynamic>> additionalDetails =
      <Map<String, dynamic>>[].obs;

// Method to add a new additional detail entry
  void addAdditionalDetail() {
    additionalDetails.add({
      'name': ''.obs,
      'email': ''.obs,
      'phone': ''.obs,
    });
  }

// Method to remove an additional detail entry
  void removeAdditionalDetail(int index) {
    if (additionalDetails.length > 1) {
      additionalDetails.removeAt(index);
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Listeners for customer side calculations
    ever(roomsCount, (_) => calculateCustomerSide());
    ever(Foreign_Sale_Rate, (_) => calculateCustomerSide());
    ever(totalSellingAmount, (_) => calculateCustomerSide(fromTotal: true));
    ever(roeSellingRate, (_) => calculateAll());

    // Listeners for supplier side calculations
    ever(nights, (_) => calculateSupplierSide());
    ever(roomPerNightBuying, (_) => calculateSupplierSide());
    ever(totalBuyingAmount, (_) => calculateSupplierSide(fromTotal: true));
  }
}
