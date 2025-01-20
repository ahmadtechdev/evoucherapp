import 'package:get/get.dart';

class SettleInvoiceController extends GetxController {
  // Dummy data for the invoices
  final List<Map<String, dynamic>> invoices = [
    {
      "id": "TV-113",
      "date": "Fri, 27 Jan 2023",
      "description": "ABC-1234y34567887-HJH-BVJ-ST",
      "totalAmount": 536.00,
      "settledAmount": 0.00,
      "remainingAmount": 536.00,
    },
    {
      "id": "HV-320",
      "date": "Wed, 19 Jul 2023",
      "description": "UpdTEST-TESTHOTELNAME-FAISALABAD-AFGHANISTAN",
      "totalAmount": 60.00,
      "settledAmount": 0.00,
      "remainingAmount": 60.00,
    },
    {
      "id": "HV-321",
      "date": "Wed, 19 Jul 2023",
      "description": "UpdTEST-TESTHOTELNAME-FAISALABAD-AFGHANISTAN",
      "totalAmount": 1.00,
      "settledAmount": 0.00,
      "remainingAmount": 1.00,
    },
    {
      "id": "TV-327",
      "date": "Fri, 04 Aug 2023",
      "description": "AFAQALI-21445464541655-LHE-KHI-PK",
      "totalAmount": 16500.00,
      "settledAmount": 3000.00,
      "remainingAmount": 13500.00,
    },
    {
      "id": "VV-328",
      "date": "Fri, 04 Aug 2023",
      "description": "AFAQ-EK12151-UMMRAH--KSA(P)",
      "totalAmount": 8000.00,
      "settledAmount": 0.00,
      "remainingAmount": 8000.00,
    },
  ];

  var selectedInvoices = <Map<String, dynamic>>[].obs;
  final double totalPayment = 50000.00;

  double get totalSettled =>
      selectedInvoices.fold(0.0, (sum, invoice) => sum + (invoice['settled'] ?? 0.0));
  double get difference => totalPayment - totalSettled;

  void toggleInvoiceSelection(Map<String, dynamic> invoice) {
    if (selectedInvoices.contains(invoice)) {
      selectedInvoices.remove(invoice);
    } else {
      selectedInvoices.add(invoice);
    }
    print(selectedInvoices);
  }

  void setSettledAmount(Map<String, dynamic> invoice, String value) {
    invoice['settled'] = double.tryParse(value) ?? 0.0;
  }
}