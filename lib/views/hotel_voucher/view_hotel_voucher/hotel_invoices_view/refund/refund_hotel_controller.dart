import 'package:get/get.dart';

class RefundHotelController extends GetxController {
  // Customer refund data
  var customerRefundData = {
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
    'No. of Rooms': '1',
    'No. of Adults': '2',
    'No. of Child': '0',
    'Refund to Per Night Sale': '100.00',
    'Refund to Total Sale Amount': '200.00',
    'Refund to Rate of Exchange': '70.00',
    'Currency': 'pkr',
    'Refund to PKR Total Selling': '14000.00',
  }.obs;

  // Supplier refund data
  var supplierRefundData = {
    'Supplier Account': 'Afaq Travels',
    'Supplier Confirmation Number': '',
    'Hotel Confirmation Number': '',
    'Consultant Name': 'AFAQ',
    'Refund from Per Night Buying': '80.00',
    'Refund from Total Buying Amount': '160.00',
    'Refund from Rate of Exchange': '78.00',
    'Currency': 'riyal',
    'Refund from PKR Total Buying': '12480.00',
    'Voucher Profit': '1520.00',
    'Voucher Loss': '0.00',
    'Now Profit': '1520.00',
    'Now Loss': '0.00',
  }.obs;

  // Date controllers
  var refundDate = DateTime.now().obs;
  var cancellationDate = DateTime.now().obs;
  var remarks = ''.obs;

  // Update refund date
  void updateRefundDate(DateTime date) {
    refundDate.value = date;
  }

  // Update cancellation date
  void updateCancellationDate(DateTime date) {
    cancellationDate.value = date;
  }

  // Update remarks
  void updateRemarks(String value) {
    remarks.value = value;
  }

  // Process refund
  void processRefund() {
    // Implement refund logic here
    // print('Processing refund...');
    // print('Refund Date: ${refundDate.value}');
    // print('Cancellation Date: ${cancellationDate.value}');
    // print('Remarks: ${remarks.value}');
  }
}