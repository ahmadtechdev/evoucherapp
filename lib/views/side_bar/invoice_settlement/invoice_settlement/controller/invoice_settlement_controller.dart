import 'package:evoucher/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class InvoiceSettlementController extends GetxController {
  var selectedAccount = ''.obs;
  var dateFrom = DateTime.now().obs;
  var dateTo = DateTime.now().obs;
  var invoices = [].obs;

  @override
  void onInit() {
    super.onInit();

    // Set dateFrom to the first day of the current month
    dateFrom.value = DateTime(DateTime.now().year, DateTime.now().month);
    fetchInvoices();

  }

  void setAccount(String account) {
    selectedAccount.value = account;
  }

  void setDateRange(DateTime from, DateTime to) {
    dateFrom.value = from;
    dateTo.value = to;
  }

  fetchInvoices() async {
    try {
      // Format dates as "YYYY-MM-DD"
      final fromDate = DateFormat('yyyy-MM-dd').format(dateFrom.value);
      final toDate = DateFormat('yyyy-MM-dd').format(dateTo.value);

      // Call the API service method
      final response = await ApiService().fetchDateRangeReport(
          endpoint: 'invoiceSettlementVoucher',
          fromDate: fromDate,
          toDate: toDate,
          additionalParams: {'account': selectedAccount.value});

      if (response['status'] == 'success') {
        print(response);
        var invoiceData = response['data'];

        // Handle null values by using null-aware operators (??) or checks
        invoices.value = invoiceData.map((invoice) {
          // Safely convert to double if it's a valid number or default to 0.0
          double safeDouble(String value) {
            try {
              return double.parse(value);
            } catch (e) {
              return 0.0; // Return 0.0 if parsing fails
            }
          }

          return {
            'voucher_id': invoice['voucher_id'] ?? '',
            'voucher_name': invoice['voucher_name'] ?? '',
            'full_voucher_name': invoice['full_voucher_name'] ?? '',
            'date': invoice['date'] ?? '',
            'description': invoice['description'] ?? '',
            'total_amount': invoice['total_amount']?.toString() ?? '0',
            'settled_amount': invoice['settled_amount']?.toString() ?? '0',
            'remaining_amount': invoice['remaining_amount']?.toString() ?? '0',
            'currency': invoice['currency'] ?? '', // Handling null currency
            'status': invoice['status'] ?? '',
            'can_select': invoice['can_select'] ?? false,
          };
        }).toList();

        print(invoices);
      } else {
        Get.snackbar('Error', 'Failed to fetch invoices');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }
}
