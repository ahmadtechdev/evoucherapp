import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:evoucher/common_widget/round_text_field.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import 'controller/daily_cash_book_controller.dart';

// Import required packages
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:flutter/material.dart';
class DailyCashBook extends StatelessWidget {
  final DailyCashBookController controller = Get.put(DailyCashBookController());

  DailyCashBook({super.key});

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
                  style: const pw.TextStyle(fontSize: 14),
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
            cellStyle: const pw.TextStyle(),
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

  Future<void> _exportToExcel(BuildContext context) async {
    // Create a new Excel file
    final excel = Excel.createExcel();
    final sheet = excel['Daily Cash Book'];

    // Add headers
    sheet.appendRow([
      TextCellValue('V#'),
      TextCellValue('Date'),
      TextCellValue('Description'),
      TextCellValue('Receipt'),
      TextCellValue('Payment'),
      TextCellValue('Balance')
    ]);

    // Add transaction data
    for (var transaction in controller.transactions) {
      sheet.appendRow([
        TextCellValue(transaction.id.toString()),
        TextCellValue(controller.formatDate(transaction.date)),
        TextCellValue(transaction.description),
        DoubleCellValue(transaction.receipt),
        DoubleCellValue(transaction.payment),
        DoubleCellValue(transaction.balance)
      ]);
    }

    // Add summary rows
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue('Total Receipt'),
      DoubleCellValue(controller.totalReceipt)
    ]);
    sheet.appendRow([
      TextCellValue('Total Payment'),
      DoubleCellValue(controller.totalPayment)
    ]);
    sheet.appendRow([
      TextCellValue('Closing Balance'),
      DoubleCellValue(controller.closingBalance)
    ]);

    // Save the file
    String downloadsPath = '/storage/emulated/0/Download';
    String filePath = '$downloadsPath/daily_cash_book_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      try {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel file exported to $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving file: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to export Excel file')),
      );
    }
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
                      margin:  const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: TColor.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'V# ${transaction.id}',
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                        color: TColor.primaryText,
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
                                        color: TColor.primaryText,
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
                                        color: TColor.primaryText,
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