import 'package:evoucher_new/service/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BspReportController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  var endDate = DateTime.now().obs;

  var tickets = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Change to RxDouble directly
  final RxDouble totalAmount = 0.0.obs;
  final RxInt totalTickets = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  void fetchTickets() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format dates for the API request
      String formattedFromDate =
      DateFormat('yyyy-MM-dd').format(startDate.value);
      String formattedToDate = DateFormat('yyyy-MM-dd').format(endDate.value);

      // Make API call
      final response = await _apiService.fetchDateRangeReport(
        endpoint: 'bspReport', // Adjust the endpoint as needed
        fromDate: formattedFromDate,
        toDate: formattedToDate,
      );

      // Process the response
      if (response['status'] == 'success') {
        // Flatten the daily reports into a single list of tickets
        List<Map<String, dynamic>> allTickets = [];

        for (var dailyReport in response['data']['daily_reports']) {
          for (var ticket in dailyReport['tickets']) {
            allTickets.add({
              'v_number': ticket['voucher_number'],
              'date': ticket['date'],
              'pax': ticket['pax_name'],
              'ticket_number': ticket['ticket_number'],
              'airline': ticket['airline'],
              'sector': ticket['sector'],
              'buying':
              double.parse(ticket['buying_amount'].replaceAll(',', '')),
              'supplier': ticket['supplier_account'],
              'selling':
              double.parse(ticket['selling_amount'].replaceAll(',', '')),
            });
          }
        }

        tickets.value = allTickets;

        // Update total amount and ticket count
        totalAmount.value = double.parse(response['data']['totals']
        ['total_amount']
            .toString()
            .replaceAll(',', ''));
        totalTickets.value =
            int.parse(response['data']['totals']['total_tickets'].toString());
      } else {
        errorMessage.value = 'Failed to load tickets';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      print('Error in fetchTickets: ${e.toString()}'); // Added for debugging
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    fetchTickets();
  }
}
