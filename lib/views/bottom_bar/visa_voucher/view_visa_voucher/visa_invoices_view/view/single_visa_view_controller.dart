// ignore_for_file: avoid_print

import 'package:get/get.dart';

class SingleVisaViewController extends GetxController {
  final customerData = RxMap<String, dynamic>({
    'Customer Account': 'Afaq Travels',
    'Customer Name': 'AFAQ ZAMIR',
    'Passport No': '1887987989',
    'Visa No': '78982290',
    'V. Type': 'WORK',
    'Country': 'DUBAI',
    'Foreign Sale Rate': '100.00',
    'Rate of Exchange': '10.00',
    'PKR Total Selling': '1000.00',
    'Phone No': '03107852255'
  });

  final receivingData = RxList([
    {'id': 'RV#842', 'amount': '800'},
    {'id': 'RV#843', 'amount': '200'}
  ]);

  final supplierData = RxMap<String, dynamic>({
    'Supplier Account': 'BASHIR IBRAHEEM',
    'Consultant Name': 'Zain Sajjid',
    'Foreign Purchase Rate': '80.00',
    'Rate of Exchange': '10.00',
    'Currency': 'dirham',
    'PKR Total Buying': '800.00',
    'Profit': '200.00',
    'Loss': '0.00',
    'Status': 'Pending',
    'Remarks': 'TESTING ENTRY',
    'Total Debit': '2',
    'Total Credit': '2',
  });

  // Date controller
  final selectedDate = DateTime.now().obs;

  // Status tracking
  final status = 'Pending'.obs;

  void editVoucher() => print('Edit Voucher pressed');
  void getInvoice(String number) => print('Get Invoice #$number pressed');
  void getForeignInvoice(String number) =>
      print('Get Foreign Invoice #$number pressed');
  void voidDeleteVoucher() => print('Void/Delete Voucher pressed');
}
