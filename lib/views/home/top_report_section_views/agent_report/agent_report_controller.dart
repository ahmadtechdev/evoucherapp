// transaction_controller.dart
import 'package:get/get.dart';

class AgentReportController extends GetxController {
  var startDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var endDate = DateTime.now().obs;
  
  var transactions = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load initial dummy data
    transactions.value = [
      {
        'date': '2024-01-22',
        'name': 'John Smith',
        'email': 'john@example.com',
        'receipt': 1500.00,
        'payment': 500.00,
        'balance': 1000.00,
      },
      {
        'date': '2024-01-22',
        'name': 'John Smith',
        'email': 'john@example.com',
        'receipt': 1500.00,
        'payment': 500.00,
        'balance': 1000.00,
      },
      // 
      // Add more dummy data as needed
    ];
  }
  
  double get totalReceipt => transactions.fold(0.0, (sum, item) => sum + (item['receipt'] as double));
  double get totalPayment => transactions.fold(0.0, (sum, item) => sum + (item['payment'] as double));
  double get closingBalance => totalReceipt - totalPayment;
  
  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    // Here you would typically fetch new data based on date range
    fetchTransactions();
  }
  
  void fetchTransactions() {
    // Implement your API call here
    // For now, we'll just use dummy data
    // transactions.value = await yourApiCall();
  }
  
  void printTransactions() {
    // Implement print functionality
  }
}
