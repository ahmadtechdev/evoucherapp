import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/dart_selector2.dart';
import 'all_visa_sale_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VisaSalesReport extends StatefulWidget {
  const VisaSalesReport({super.key});

  @override
  State<VisaSalesReport> createState() => _VisaSalesReportState();
}

class _VisaSalesReportState extends State<VisaSalesReport> {
  DateTime toDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  final AllVisaSaleController controller = Get.put(AllVisaSaleController());

  @override
  void initState() {
    super.initState();
    // fromDate = DateTime(toDate.year, toDate.month, 1);
    fromDate = DateTime(toDate.year, toDate.month, toDate.day - 2);
  }

  Future<void> _generateAndPrintPDF() async {
    try {
      final pdf = pw.Document();

      // Load the logo
      final ByteData logoData = await rootBundle.load('assets/img/newLogo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final logo = pw.MemoryImage(logoBytes);

      // Get data from controller
      final transactions = controller.transactions;
      final grandTotals = controller.grandTotals;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo, width: 60, height: 60),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Hotel Sales Report',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'From: ${fromDate.toString().split(' ')[0]}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'To: ${toDate.toString().split(' ')[0]}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          footer: (context) => pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          build: (context) => [
            pw.SizedBox(height: 20),

            // Daily Records
            ...transactions.map((transaction) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  transaction['date'],
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey400,
                    width: 0.5,
                  ),
                  children: [
                    // Table Header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      children: [
                        _buildTableCell('Total Purchase', isHeader: true),
                        _buildTableCell('Total Sale', isHeader: true),
                        _buildTableCell('Total P/L', isHeader: true),
                      ],
                    ),
                    // Data Row
                    pw.TableRow(
                      children: [
                        _buildTableCell(
                          'Rs ${transaction['purchase'].toStringAsFixed(2)}',
                        ),
                        _buildTableCell(
                          'Rs ${transaction['sale'].toStringAsFixed(2)}',
                        ),
                        _buildTableCell(
                          'Rs ${transaction['profit'].toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ],
                ),

                // Detailed entries with page breaks if needed
                ...transaction['details'].map((detail) => pw.Container(
                  margin: const pw.EdgeInsets.only(top: 5),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey400),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Voucher: ${detail['voucherNo']}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Customer: ${detail['customerAccount']}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Supplier: ${detail['supplierAccount']}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Pax Name: ${detail['paxName']}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Row(
                        mainAxisAlignment:
                        pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'P: Rs ${detail['pAmount']}',
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            'S: Rs ${detail['sAmount']}',
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            'P/L: Rs ${detail['pnl']}',
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
                pw.SizedBox(height: 10),
              ],
            )),

            // Grand Totals at the end
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey400),
              ),
              child: pw.Table(
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _buildTableCell('Total Purchases', isHeader: true),
                      _buildTableCell('Total Sales', isHeader: true),
                      _buildTableCell('Total P/L', isHeader: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(
                        'Rs ${controller.parseAmount(grandTotals['total_purchases'] ?? '0.00').toStringAsFixed(2)}',
                      ),
                      _buildTableCell(
                        'Rs ${controller.parseAmount(grandTotals['total_sales'] ?? '0.00').toStringAsFixed(2)}',
                      ),
                      _buildTableCell(
                        'Rs ${controller.parseAmount(grandTotals['total_profit_loss'] ?? '0.00').toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? pw.FontWeight.bold : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Visa Sales Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          'From Date',
                          fromDate,
                              (date) => setState(() => fromDate = date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateSelector(
                          'To Date',
                          toDate,
                              (date) => setState(() => toDate = date),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _generateAndPrintPDF();
                        },
                        icon: const Icon(Icons.print, size: 20),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                    () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.transactions.isEmpty
                    ? const Center(
                  child: Text(
                    "No records in this range",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    return CollapsibleTransactionCard(
                      transaction: controller.transactions[index],
                      index: index,
                      controller: controller,
                    );
                  },
                ),
              ),
            ),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      String label, DateTime selectedDate, Function(DateTime) onChanged) {
    return DateSelector2(
        fontSize: 14,
        initialDate: selectedDate,
        onDateChanged: (date) {
          onChanged(date);
          // Format dates as required by API (YYYY-MM-DD)
          String formattedFromDate = fromDate.toString().split(' ')[0];
          String formattedToDate = toDate.toString().split(' ')[0];
          controller.fetchTransactions(
            fromDate: formattedFromDate,
            toDate: formattedToDate,
          );
        },
        label: label);
  }

  // Widget _buildTransactionInfo(String label, double amount, Color color) {
  //   return Expanded(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: TColor.secondaryText,
  //             fontSize: 12,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           'Rs ${amount.toStringAsFixed(2)}',
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTotalSection() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTotalItem(
              'Total Purchases',
              controller.parseAmount(
                  controller.grandTotals['total_purchases'] ?? '0.00'),
              TColor.third,
            ),
            _buildTotalItem(
              'Total Sales',
              controller
                  .parseAmount(controller.grandTotals['total_sales'] ?? '0.00'),
              TColor.secondary,
            ),
            _buildTotalItem(
              'Total P/L',
              controller.parseAmount(
                  controller.grandTotals['total_profit_loss'] ?? '0.00'),
              TColor.secondary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTotalItem(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs ${amount.toStringAsFixed(1)}',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CollapsibleTransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final int index;
  final AllVisaSaleController controller;

  const CollapsibleTransactionCard({
    super.key,
    required this.transaction,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.expandedStates[index];

      return Column(
        children: [
          // Detailed View (Visible when expanded)
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                border: Border.all(color: TColor.primary.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transaction['details'].length,
                itemBuilder: (context, detailIndex) {
                  final detail = transaction['details'][detailIndex];
                  return Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColor.readOnlyTextField.withOpacity(0.7),
                      border: detailIndex < transaction['details'].length - 1
                          ? Border(
                        bottom: BorderSide(
                          color: TColor.primary.withOpacity(0.1),
                          width: 1,
                        ),
                      )
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  detail['voucherNo'],
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Customer: ${detail['customerAccount']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Supplier: ${detail['supplierAccount']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person_pin_outlined,
                                size: 16,
                                color: TColor.secondaryText,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                detail['paxName'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: TColor.primaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildAmountColumn(
                                  'Purchase',
                                  'Rs ${detail['pAmount']}',
                                  TColor.third,
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: TColor.primary.withOpacity(0.1),
                                ),
                                _buildAmountColumn(
                                  'Sale',
                                  'Rs ${detail['sAmount']}',
                                  TColor.secondary,
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: TColor.primary.withOpacity(0.1),
                                ),
                                _buildAmountColumn(
                                  'P/L',
                                  'Rs ${detail['pnl']}',
                                  detail['pnl'] > 0
                                      ? TColor.secondary
                                      : TColor.third,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Main Transaction Card (keeping the existing code)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: TColor.white,
              border: Border.all(
                color: TColor.primary.withOpacity(0.2),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: TColor.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction['date'],
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${transaction['entries']} Entries',
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColor.primary,
                            ),
                            onPressed: () => controller.toggleExpanded(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTransactionInfo(
                          'Purchase', transaction['purchase'], TColor.third),
                      _buildTransactionInfo(
                          'Sale', transaction['sale'], TColor.secondary),
                      _buildTransactionInfo(
                        'Profit/Loss',
                        transaction['profit'],
                        transaction['profit'] > 0
                            ? TColor.secondary
                            : TColor.third,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionInfo(String label, double amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs ${amount.toStringAsFixed(1)}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountColumn(String label, String amount, Color amountColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
