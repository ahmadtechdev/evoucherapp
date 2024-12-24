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
  final customerAccount = TextEditingController();
  final customerName = TextEditingController();
  final phoneNo = TextEditingController();
  final passportNo = TextEditingController();
  final country = TextEditingController();
  final visaNo = TextEditingController();
  final visaType = TextEditingController();

  // Booking Details (unchanged)

  // Selling Side Calculations (modified)
  // custmer side
  final foreignSaleRateController = TextEditingController();
  final totalSellingAmountController = RxString('0');
  final roeSellingRateController = TextEditingController(text: '1');
  final sellingCurrencyController = TextEditingController();

  void calculateTotalSelling() {
    double foreignSaleRate = double.tryParse(foreignSaleRateController.text) ?? 0.0;
    double exchangeRate = double.tryParse(roeSellingRateController.text) ?? 1.0;
    double totalSelling = foreignSaleRate * exchangeRate;

    // Update the total selling amount dynamically
    totalSellingAmountController.value = totalSelling.toStringAsFixed(0);
  }

  // suplier side
  final pkrTotalBuying = RxString('0');
  final supplierDetailController = TextEditingController();
  final foreignPurchaseRateController = TextEditingController();
  final supplierROESellingRateController = TextEditingController(text: '1');
  final profit = RxString('0.00');
  final loss = RxString('0.00');

  void supplierCalculateTotalSelling() {
    double foreignSaleRate = double.tryParse(foreignPurchaseRateController.text) ?? 0.0;
    double exchangeRate = double.tryParse(supplierROESellingRateController.text) ?? 1.0;
    double totalBuyingAmount = foreignSaleRate * exchangeRate;

    // Update the total selling amount dynamically
    pkrTotalBuying.value = totalBuyingAmount.toStringAsFixed(0);
    var totalSellingAmount1 = double.tryParse(totalSellingAmountController.value);

    // Calculate profit or loss
    if (totalBuyingAmount > totalSellingAmount1!) {
      loss.value = (totalBuyingAmount - totalSellingAmount1).round().toString();
      profit.value = ''; // Clear loss field
    } else if (totalBuyingAmount < totalSellingAmount1) {
      profit.value =
          (totalSellingAmount1 - totalBuyingAmount).round().toString();
      loss.value = ''; // Clear profit field
    } else {
      profit.value = '';
      loss.value = '';
    }
  }

  final hotelConfirmationNo = TextEditingController();
  final consultantName = TextEditingController();

  final roomPerNightBuying = TextEditingController();
  final totalBuyingAmount = TextEditingController();
  final buyingCurrency = TextEditingController();

  // Summary (unchanged)

  void updateDateRange(DateTimeRange newRange) {
    dateRange.value = newRange;
  }

  void updateNights(int newNights) {
    if (newNights > 0) {
      dateRange.value = DateTimeRange(
        start: dateRange.value.start,
        end: dateRange.value.start.add(Duration(days: newNights)),
      );
    }
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

}
