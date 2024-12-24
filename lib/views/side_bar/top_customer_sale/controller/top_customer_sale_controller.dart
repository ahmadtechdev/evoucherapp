import 'package:get/get.dart';

import '../models/top_customer_sale_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CustomerReportController extends GetxController {
  final selectedYear = 2024.obs;
  final searchQuery = ''.obs;

  final RxList<Customer> activeCustomers = <Customer>[].obs;
  final RxList<Customer> zeroSaleCustomers = <Customer>[].obs;
  final RxList<Customer> filteredActiveCustomers = <Customer>[].obs;
  final RxList<Customer> filteredZeroSaleCustomers = <Customer>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeCustomers();
  }

  void initializeCustomers() {
    final List<Map<String, dynamic>> activeCustomersData =[
      {
        'rank': 1,
        'name': 'MOHSIN ALI',
        'ticket': 0.00,
        'hotel': 385000.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 385000.00,
        'percentage': 42.2524
      },
      {
        'rank': 2,
        'name': 'AHMED C/O MUNIR',
        'ticket': 60000.00,
        'hotel': 100000.00,
        'visa': 50480.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 210480.00,
        'percentage': 23.0995
      },
      {
        'rank': 3,
        'name': 'HUSSNAIN ALI',
        'ticket': 23860.00,
        'hotel': 124000.00,
        'visa': 32850.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 180710.00,
        'percentage': 19.8323
      },
      {
        'rank': 4,
        'name': 'ALI AMEEN',
        'ticket': 80000.00,
        'hotel': 25000.00,
        'visa': 30000.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 135000.00,
        'percentage': 14.8158
      },
    ];

    final List<Map<String, dynamic>> zeroSaleCustomersData = [
      {
        'rank': 5,
        'name': 'MR Afaq',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 6,
        'name': 'Mr. Adnan',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 7,
        'name': 'Mr. Adnan Kashif',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 8,
        'name': 'MEHRAN WALKING CUSTOMER',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
    ];

    activeCustomers.value = activeCustomersData.map((e) => Customer.fromJson(e)).toList();
    zeroSaleCustomers.value = zeroSaleCustomersData.map((e) => Customer.fromJson(e)).toList();

    filteredActiveCustomers.value = activeCustomers;
    filteredZeroSaleCustomers.value = zeroSaleCustomers;
  }

  void updateYear(int year) {
    selectedYear.value = year;
    // Here you can add API call to fetch data for the selected year
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredActiveCustomers.value = activeCustomers;
      filteredZeroSaleCustomers.value = zeroSaleCustomers;
      return;
    }

    filteredActiveCustomers.value = activeCustomers
        .where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    filteredZeroSaleCustomers.value = zeroSaleCustomers
        .where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> printReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Top Customer Sale Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              'Year: ${selectedYear.value}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
          ],
        ),
        build: (context) => [
          _buildActiveSalesSection(),
          pw.SizedBox(height: 20),
          _buildZeroSalesSection(),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildActiveSalesSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Active Customers',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...activeCustomers.map((customer) => _buildCustomerRow(customer)),
      ],
    );
  }

  pw.Widget _buildZeroSalesSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Accounts with Zero Sales',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...zeroSaleCustomers.map((customer) => _buildCustomerRow(customer)),
      ],
    );
  }

  pw.Widget _buildCustomerRow(Customer customer) {
    final formatter = NumberFormat('#,##0.00');

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Rank ${customer.rank} - ${customer.name}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${customer.percentage.toStringAsFixed(2)}%',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Ticket Sale:', customer.ticket, formatter),
              _buildSaleItem('Hotel Sale:', customer.hotel, formatter),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Visa Sale:', customer.visa, formatter),
              _buildSaleItem('Transport Sale:', customer.transport, formatter),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Sale:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Rs. ${formatter.format(customer.total)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSaleItem(String label, double amount, NumberFormat formatter) {
    return pw.Expanded(
      child: pw.Row(
        children: [
          pw.Text(label),
          pw.SizedBox(width: 5),
          pw.Text('Rs. ${formatter.format(amount)}'),
        ],
      ),
    );
  }
}