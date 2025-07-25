import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../service/api_service.dart';
import '../models/top_customer_sale_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CustomerReportController extends GetxController {
  final ApiService apiService = ApiService();

  final selectedYear = 2025.obs;
  final searchQuery = ''.obs;

  final RxList<Customer> activeCustomers = <Customer>[].obs;
  final RxList<Customer> zeroSaleCustomers = <Customer>[].obs;
  final RxList<Customer> filteredActiveCustomers = <Customer>[].obs;
  final RxList<Customer> filteredZeroSaleCustomers = <Customer>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerReport();
  }

  Future<void> fetchCustomerReport() async {
    try {
      isLoading.value = true;

      final response = await apiService.postRequest(
        endpoint: 'topReport',
        body: {'year': selectedYear.value.toString(), "subhead": "customer"},
      );

      if (response['status'] == 'success') {
        final data = response['data'];

        // Parse non-zero sales customers
        final nonZeroSales = (data['non_zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Customer.fromJson(entry.value, entry.key + 1))
            .toList();

        // Parse zero sales customers
        final zeroSales = (data['zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Customer.fromJson(
                  entry.value,
                  nonZeroSales.length + entry.key + 1,
                ))
            .toList();

        activeCustomers.value = nonZeroSales;
        zeroSaleCustomers.value = zeroSales;
        filteredActiveCustomers.value = nonZeroSales;
        filteredZeroSaleCustomers.value = zeroSales;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch customer report: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateYear(int year) {
    selectedYear.value = year;
    fetchCustomerReport();
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

  pw.Widget _buildSaleItem(
      String label, double amount, NumberFormat formatter) {
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
