import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/snackbar.dart';

import 'package:get/get.dart';

import '../../../../service/api_service.dart';
import '../models/top_agent_sale_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class AgentReportController extends GetxController {
  final ApiService apiService = ApiService();

  final selectedYear = 2025.obs;
  final searchQuery = ''.obs;

  final RxList<Agent> activeAgents = <Agent>[].obs;
  final RxList<Agent> zeroSaleAgents = <Agent>[].obs;
  final RxList<Agent> filteredActiveAgents = <Agent>[].obs;
  final RxList<Agent> filteredZeroSaleAgents = <Agent>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgentReport();
  }

  Future<void> fetchAgentReport() async {
    try {
      isLoading.value = true;

      final response = await apiService.postRequest(
        endpoint: 'topReport',
        body: {'year': selectedYear.value.toString(), "subhead": "agent"},
      );

      if (response['status'] == 'success') {
        final data = response['data'];

        // Parse non-zero sales customers
        final nonZeroSales = (data['non_zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Agent.fromJson(entry.value, entry.key + 1))
            .toList();

        // Parse zero sales customers
        final zeroSales = (data['zero_sales'] as List)
            .asMap()
            .entries
            .map((entry) => Agent.fromJson(
                  entry.value,
                  nonZeroSales.length + entry.key + 1,
                ))
            .toList();

        activeAgents.value = nonZeroSales;
        zeroSaleAgents.value = zeroSales;
        filteredActiveAgents.value = nonZeroSales;
        filteredZeroSaleAgents.value = zeroSales;
      }
    } catch (e) {
      CustomSnackBar(
          message: 'Failed to fetch customer report: ${e.toString()}',
          backgroundColor: TColor.third);
    } finally {
      isLoading.value = false;
    }
  }

  void updateYear(int year) {
    selectedYear.value = year;
    fetchAgentReport();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredActiveAgents.value = activeAgents;
      filteredZeroSaleAgents.value = zeroSaleAgents;
      return;
    }

    filteredActiveAgents.value = activeAgents
        .where((customer) =>
            customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    filteredZeroSaleAgents.value = zeroSaleAgents
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
                'Top Agent Sale Report',
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
          'Active Agents',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...activeAgents.map((customer) => _buildAgentRow(customer)),
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
        ...zeroSaleAgents.map((customer) => _buildAgentRow(customer)),
      ],
    );
  }

  pw.Widget _buildAgentRow(Agent agent) {
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
                'Rank ${agent.rank} - ${agent.name}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${agent.percentage.toStringAsFixed(2)}%',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Ticket Sale:', agent.ticket, formatter),
              _buildSaleItem('Hotel Sale:', agent.hotel, formatter),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleItem('Visa Sale:', agent.visa, formatter),
              _buildSaleItem('Transport Sale:', agent.transport, formatter),
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
                'Rs. ${formatter.format(agent.total)}',
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
