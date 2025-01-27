// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleHotelViewController extends GetxController {
  var customerData = {
    'Customer Account': 'Adam',
    'PAX Name': 'HASSAN',
    'Hotel Name': 'ABC TEST GTEL',
    'Country': 'SAUDIA',
    'City': 'MECCA',
    'Check In': 'Thu, 31 Oct 2024',
    'Check Out': 'Sat, 02 Nov 2024',
    'Nights': '2',
    'Room Type': 'DOUBLE ROOM',
    'Meal': 'Room Only',
    'Rooms/Beds': '1',
    'No. of Adults': '2',
    'No. of Child': '0',
    'Per Night Sale': '100.00',
    'Total Sale Amount': '200.00',
    'Rate of Exchange': '70.00',
    'Currency': 'pkr',
    'PKR Total Selling': '14000.00',
  }.obs;

  var supplierData = {
    'Supplier Account': 'Afaq Travels',
    'Supplier Confirmation Number': '',
    'Hotel Confirmation Number': '',
    'Consultant Name': 'AFAQ',
    'Per Night Buying': '80.00',
    'Total Buying Amount': '160.00',
    'Rate of Exchange': '78.00',
    'Currency': 'riyal',
    'PKR Total Buying': '12480.00',
    'Profit': '1520.00',
    'Loss': '0.00',
  }.obs;

  var selectedHotel = ''.obs;
  var selectedRoomType = ''.obs;
  var voucherNumberController = TextEditingController();
  var cancellationDeadline = ''.obs;

  // Date controllers
  var checkInDate = DateTime.now().obs;
  var checkOutDate = DateTime.now().add(const Duration(days: 1)).obs;
  
  void editVoucher() => print('Edit Voucher pressed');
  void getInvoice() => print('Get Invoice pressed');
  void getForeignInvoice() => print('Foreign Invoice pressed');
  void refundNow() => print('Refund Now pressed');
  void voidDelete() => print('Void/Delete pressed');

  @override
  void onClose() {
    voucherNumberController.dispose();
    super.onClose();
  }
}