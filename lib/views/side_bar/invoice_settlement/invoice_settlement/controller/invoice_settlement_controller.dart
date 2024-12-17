import 'package:get/get.dart';

class InvoiceSettlementController extends GetxController {
  var selectedAccount = ''.obs;
  var dateFrom = DateTime.now().obs;
  var dateTo = DateTime.now().obs;

  void setAccount(String account) {
    selectedAccount.value = account;
  }

  void setDateRange(DateTime from, DateTime to) {
    dateFrom.value = from;
    dateTo.value = to;
  }
}