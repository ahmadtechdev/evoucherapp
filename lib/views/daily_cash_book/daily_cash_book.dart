import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:evoucher/common_widget/round_textfield.dart';
import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import 'controller/daily_cash_book_controller.dart';

// Import required packages
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as ex;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DailyCashBook extends StatelessWidget {
  final DailyCashBookController controller = Get.put(DailyCashBookController());

  // PDF Export Method
  Future<void> _exportToPDF(BuildContext context) async {
    final pdf = pw.Document();
    // Load the logo
    final logoImage =
    await rootBundle.load('assets/img/logo.png');
    final logo =
    pw.MemoryImage(logoImage.buffer.asUint8List());
    // Add logo and company name to the header
    pdf.addPage(
      pw.MultiPage(
        header: (context) =>
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment:
                  pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logo, width: 100, height: 100),
                    pw.Text(
                      'Journey Online',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.Text(
                  'Daily Cash Book Report',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Date: ${controller.formatDate(
                      controller.selectedDate.value)}',
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
        build: (context) =>
        [
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>[
                'V#',
                'Date',
                'Description',
                'Receipt',
                'Payment',
                'Balance'
              ],
              ...controller.transactions.map((transaction) =>
              [
                transaction.id.toString(),
                controller.formatDate(transaction.date),
                transaction.description,
                'Rs ${transaction.receipt.toStringAsFixed(2)}',
                'Rs ${transaction.payment.toStringAsFixed(2)}',
                'Rs ${transaction.balance.toStringAsFixed(2)}',
              ]),
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(),
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Total Receipt: Rs ${controller.totalReceipt.toStringAsFixed(
                      2)}'),
              pw.Text(
                  'Total Payment: Rs ${controller.totalPayment.toStringAsFixed(
                      2)}'),
              pw.Text('Closing Balance: Rs ${controller.closingBalance
                  .toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );

    // Save and print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Excel Export Method
  Future<void> _exportToExcel(BuildContext context) async {
    // Create a new Excel file
    final ex.Excel excel = ex.Excel.createExcel();
    final ex.Sheet sheet = excel['Daily Cash Book'];

    // Add headers
    sheet.appendRow([
      'V#' as ex.CellValue,
      'Date' as ex.CellValue,
      'Description' as ex.CellValue,
      'Receipt' as ex.CellValue,
      'Payment' as ex.CellValue,
      'Balance' as ex.CellValue
    ]);

    // Add transaction data
    for (var transaction in controller.transactions) {
      sheet.appendRow([
        transaction.id.toString() as ex.CellValue,
        controller.formatDate(transaction.date) as ex.CellValue,
        transaction.description as ex.CellValue,
        transaction.receipt.toStringAsFixed(2) as ex.CellValue,
        transaction.payment.toStringAsFixed(2) as ex.CellValue,
        transaction.balance.toStringAsFixed(2) as ex.CellValue
      ]);
    }

    // Add summary rows
    sheet.appendRow([]);
    sheet.appendRow([
      'Total Receipt' as ex.CellValue,
      controller.totalReceipt.toStringAsFixed(2) as ex.CellValue
    ]);
    sheet.appendRow([
      'Total Payment' as ex.CellValue,
      controller.totalPayment.toStringAsFixed(2) as ex.CellValue
    ]);
    sheet.appendRow([
      'Closing Balance' as ex.CellValue,
      controller.closingBalance.toStringAsFixed(2) as ex.CellValue
    ]);

    // Save the file
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/daily_cash_book_${DateTime
        .now()
        .millisecondsSinceEpoch}.xlsx');
    await file.writeAsBytes(excel.save()!);

    // Show a snackbar to confirm export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel file saved to ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Cash Book'),
      ),
      drawer: const CustomDrawer(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.primary.withOpacity(0.1),
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
                        child: DateSelector(
                          fontSize: screenHeight * 0.018,
                          vpad: screenHeight * 0.01,
                          initialDate: controller.selectedDate.value,
                          label: "DATE:",
                          onDateChanged: (newDate) {
                            controller.selectedDate.value = newDate;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _exportToExcel(context),
                        icon: const Icon(Icons.file_download),
                        label: const Text('Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.secondary,
                          foregroundColor: TColor.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => _exportToPDF(context),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                        ),
                      ),
                    ],
                  ),
                  SearchTextField(hintText: "Search", onChange: (query) {
                    // Implement search functionality
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: TColor.white,
                        border: Border.all(
                          color: TColor.primary.withOpacity(0.2),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'V# ${transaction.id}',
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.formatDate(transaction.date),
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              transaction.description,
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Receipt',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      'Rs ${transaction.receipt.toStringAsFixed(
                                          2)}',
                                      style: TextStyle(
                                        color: TColor.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      'Rs ${transaction.payment.toStringAsFixed(
                                          2)}',
                                      style: TextStyle(
                                        color: TColor.third,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      'Rs ${transaction.balance.toStringAsFixed(
                                          2)}',
                                      style: TextStyle(
                                        color: TColor.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalItem('Total Receipt',
                      controller.totalReceipt.toStringAsFixed(2),
                      TColor.secondary),
                  _buildTotalItem('Total Payment',
                      controller.totalPayment.toStringAsFixed(2), TColor.third),
                  _buildTotalItem('Closing Balance',
                      controller.closingBalance.toStringAsFixed(2),
                      TColor.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalItem(String label, String amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
          'Rs $amount',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}