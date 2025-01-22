// ticket_controller.dart
import 'package:get/get.dart';

class BspReportController extends GetxController {
  var startDate = DateTime.now().subtract(const Duration(days: 7)).obs;
  var endDate = DateTime.now().obs;
  
  var tickets = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load initial dummy data
    tickets.value = [
      {
        'v_number': 'TV 327',
        'date': 'Fri, 04 Aug 2023',
        'pax': 'AFAQ ALI',
        'ticket_number': '2144546541655',
        'airline': 'PIA - PK',
        'sector': 'LHE-KHI',
        'buying': 15000.00,
        'supplier': 'BSP 01-15 AUG',
      },
      {
        'v_number': 'TV 327',
        'date': 'Fri, 04 Aug 2023',
        'pax': 'AFAQ ALI',
        'ticket_number': '2144546541655',
        'airline': 'PIA - PK',
        'sector': 'LHE-KHI',
        'buying': 15000.00,
        'supplier': 'BSP 01-15 AUG',
      },
      // Add more dummy data as needed
    ];
  }
  
  double get totalAmount => tickets.fold(0.0, (sum, item) => sum + (item['buying'] as double));
  
  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    fetchTickets();
  }
  
  void fetchTickets() {
    // Implement API call here
  }
}
