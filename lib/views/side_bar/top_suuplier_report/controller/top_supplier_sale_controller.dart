import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/color_extension.dart';
import '../../../../common_widget/snackbar.dart';
import '../../../../service/api_service.dart';
import '../models/top_supplier_sale_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class SupplierReportController extends GetxController {
  final ApiService apiService = ApiService();

  final selectedYear = 2024.obs;
  final searchQuery = ''.obs;

  final RxList<Supplier> activeSupplier = <Supplier>[].obs;
  final RxList<Supplier> zeroSaleSupplier = <Supplier>[].obs;
  final RxList<Supplier> filteredActiveSupplier = <Supplier>[].obs;
  final RxList<Supplier> filteredZeroSaleSupplier = <Supplier>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSupplierReport();
  }

  Future<void> fetchSupplierReport() async {
    try {
      isLoading.value = true;

      final response = await apiService.postRequest(
        endpoint: 'topReport',
        body: {
          'year': selectedYear.value.toString(),
          "subhead":"supplier"
        },
      );

      if (response['status'] == 'success') {
        final data = response['data'];

        // Parse non-zero sales customers
        final nonZeroSales = (data['non_zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Supplier.fromJson(entry.value, entry.key + 1))
            .toList();

        // Parse zero sales customers
        final zeroSales = (data['zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Supplier.fromJson(
          entry.value,
          nonZeroSales.length + entry.key + 1,
        ))
            .toList();

        activeSupplier.value = nonZeroSales;
        zeroSaleSupplier.value = zeroSales;
        filteredActiveSupplier.value = nonZeroSales;
        filteredZeroSaleSupplier.value = zeroSales;
      }
    } catch (e) {

      CustomSnackBar(message: 'Failed to fetch Supplier report: ${e.toString()}', backgroundColor: TColor.third);
    } finally {
      isLoading.value = false;
    }
  }

  void updateYear(int year) {
    selectedYear.value = year;
    fetchSupplierReport();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredActiveSupplier.value = activeSupplier;
      filteredZeroSaleSupplier.value = zeroSaleSupplier;
      return;
    }

    filteredActiveSupplier.value = activeSupplier
        .where((customer) =>
        customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    filteredZeroSaleSupplier.value = zeroSaleSupplier
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
                'Top Supplier Sale Report',
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
          'Active Supplier',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...activeSupplier.map((customer) => _buildSupplierRow(customer)),
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
        ...zeroSaleSupplier.map((supplier) => _buildSupplierRow(supplier)),
      ],
    );
  }

  pw.Widget _buildSupplierRow(Supplier supplier) {
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
                'Rank ${supplier.rank} - ${supplier.name}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${supplier.percentage.toStringAsFixed(2)}%',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Ticket Sale:', supplier.ticket, formatter),
              _buildSaleItem('Hotel Sale:', supplier.hotel, formatter),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Visa Sale:', supplier.visa, formatter),
              _buildSaleItem('Transport Sale:', supplier.transport, formatter),
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
                'Rs. ${formatter.format(supplier.total)}',
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