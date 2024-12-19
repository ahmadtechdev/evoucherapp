import 'package:get/get.dart';

class VisaVoucherController extends GetxController {
  var ticketVouchers = <Map<String, String>>[].obs;
  var totalReceipt = 0.0.obs;
  var fromDate = '12/01/2024'.obs;
  var toDate = '12/17/2024'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize ticket vouchers data
    ticketVouchers.addAll([
      {
        'VV_ID': 'TV 917',
        'customer': 'Princess Tourism',
        'description': 'ZAID KHAN-17657334472524-DXB-KHI-EK',
        'supplier': 'EMIRATES 13DEC2024 TESTING',
        'added_by': 'Umer Liaqat',
        'visa_status': 'Pending',
        'price': '84415.00',
      },
      {
        'VV_ID': 'TV 916',
        'customer': 'Princess Tourism',
        'description': 'ZAFFAR IQBAL-17657334472513-KHI-JED-EK',
        'supplier': 'EMIRATES 13DEC2024 TESTING',
        'added_by': 'Umer Liaqat',
        'visa_status': 'Approved',
        'price': '135085.00',
      },
      {
        'VV_ID': 'TV 901',
        'customer': 'Afaq Travels',
        'description': 'zain-LHE-DXB-PK',
        'supplier': 'HBL CARD',
        'added_by': 'Umer Liaqat',
        'visa_status': 'Pending',
        'price': '80100.00',
      },
      {
        'VV_ID': 'TV 900',
        'customer': 'Afaq Travels',
        'description': 'zain-LHE-DXB-PK',
        'supplier': 'HBL CARD',
        'added_by': 'Umer Liaqat',
        'visa_status': 'Approved',
        'price': '80100.00',
      },
    ]);

    // Calculate total receipt
    _calculateTotalReceipt();
  }

  void _calculateTotalReceipt() {
    totalReceipt.value = ticketVouchers.fold(0.0, (sum, ticket) {
      return sum + double.parse(ticket['price']!);
    });
  }

  void updateDateRange(String from, String to) {
    fromDate.value = from;
    toDate.value = to;
  }
}
