import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Dummy data for transactions
  // / Added detailed transactions dat
  var transactions = [
    {
      'date': 'Dec 06, 2024',
      'entries': 2,
      'purchase': 310.0,
      'sale': 400.0,
      'profit': 150.0,
      'details': [
        {
          'voucherNo': 'TV990',
          'customerAccount': 'SUPREME TRAVELS',
          'supplierAccount': 'IATA BSP KPT MUX',
          'paxName': 'ZAID KHAN',
          'pAmount': 115834.0,
          'sAmount': 115834.0,
          'pnl': 0.0,
        },
        {
          'voucherNo': 'TV989',
          'customerAccount': 'ABC BANK',
          'supplierAccount': 'ADAM',
          'paxName': 'TEST PAX',
          'pAmount': 16000.0,
          'sAmount': 20000.0,
          'pnl': 4000.0,
        },
      ]
    },
    {
      'date': 'Dec 06, 2024',
      'entries': 2,
      'purchase': 310.0,
      'sale': 460.0,
      'profit': 150.0,
      'details': [
        {
          'voucherNo': 'TV990',
          'customerAccount': 'SUPREME TRAVELS',
          'supplierAccount': 'IATA BSP KPT MUX',
          'paxName': 'ZAID KHAN',
          'pAmount': 115834.0,
          'sAmount': 115834.0,
          'pnl': 0.0,
        },
        {
          'voucherNo': 'TV989',
          'customerAccount': 'ABC BANK',
          'supplierAccount': 'ADAM',
          'paxName': 'TEST PAX',
          'pAmount': 16000.0,
          'sAmount': 20000.0,
          'pnl': 4000.0,
        },
      ]
    },
    // Add more transactions as needed
  ].obs;

  // Track expanded state for each transaction
  final RxList<bool> expandedStates = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize expanded states for all transactions
    expandedStates.value = List.generate(transactions.length, (_) => false);
  }

  void toggleExpanded(int index) {
    expandedStates[index] = !expandedStates[index];
    expandedStates.refresh();
  }
}
