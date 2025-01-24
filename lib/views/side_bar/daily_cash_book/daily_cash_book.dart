import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/date_selecter.dart';
import '../../../common_widget/round_text_field.dart';
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
    final logoImage = await rootBundle.load('assets/img/newLogo.png');
    final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

    // Add logo and company name to the header
    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
              'Date: ${controller.formatDate(controller.selectedDate.value)}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>[
                'V#',
                'Date',
                'Description',
                'Debit',
                'Credit',
                'Balance'
              ],
              ...controller.transactions.map((transaction) => [
                transaction.voucherId,
                controller.formatDate(transaction.date),
                transaction.description,
                'Rs ${transaction.debit.toStringAsFixed(2)}',
                'Rs ${transaction.credit.toStringAsFixed(2)}',
                transaction.balance,
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
              pw.Text('Total Receipt: Rs ${controller.totalReceipt.value}'),
              pw.Text('Total Payment: Rs ${controller.totalPayment.value}'),
              pw.Text('Closing Balance: ${controller.closingBalance.value}'),
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
    try {
      // Request storage permissions (for Android 13+)
      bool isPermissionGranted = await _requestStoragePermission(context);
      if (!isPermissionGranted) {
        return; // Exit if permission is not granted
      }
      // Create a new Excel file
      final excel = Excel.createExcel();
      final sheet = excel['Daily Cash Book'];

      // Add headers
      sheet.appendRow([
        TextCellValue('V#'),
        TextCellValue('Date'),
        TextCellValue('Description'),
        TextCellValue('Debit'),
        TextCellValue('Credit'),
        TextCellValue('Balance')
      ]);

      // Add transaction data
      for (var transaction in controller.transactions) {
        sheet.appendRow([
          TextCellValue(transaction.voucherId),
          TextCellValue(controller.formatDate(transaction.date)),
          TextCellValue(transaction.description),
          DoubleCellValue(transaction.debit),
          DoubleCellValue(transaction.credit),
          TextCellValue(transaction
              .balance) // Using TextCellValue since balance includes "Dr/Cr"
        ]);
      }

      // Add summary rows
      sheet.appendRow([]);
      sheet.appendRow([
        TextCellValue('Total Receipt'),
        TextCellValue(controller.totalReceipt.value)
      ]);
      sheet.appendRow([
        TextCellValue('Total Payment'),
        TextCellValue(controller.totalPayment.value)
      ]);
      sheet.appendRow([
        TextCellValue('Closing Balance'),
        TextCellValue(controller.closingBalance.value)
      ]);

      // Save the file
      String downloadsPath = '/storage/emulated/0/Download';
      String filePath =
          '$downloadsPath/daily_cash_book_${DateTime.now().millisecondsSinceEpoch}.xlsx';
// Save the Excel file
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel file exported to $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export Excel file')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    // Check current permission status for Android 13+ (use manageExternalStorage)
    PermissionStatus status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      // Permission is already granted
      return true;
    } else if (status.isDenied) {
      // Request permission
      PermissionStatus newStatus =
      await Permission.manageExternalStorage.request();
      if (newStatus.isGranted) {
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        // Show dialog to navigate to app settings
        _showPermissionDialog(context);
      }
    }
    return false;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Permission Required'),
        content: const Text(
            'This app requires storage permission to export files. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
                            controller.fetchDailyCashBook();
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
                  SearchTextField(
                      hintText: "Search",
                      onChange: (query) {
                        // Implement search functionality
                      }),
                ],
              ),
            ),
            // Replace the transaction list builder with:
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 50,
                          color: TColor.secondaryText,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Record Found',
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: TColor.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'V# ${transaction.voucherId}',
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
                                      'Debit',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      'Rs ${transaction.debit.toStringAsFixed(2)}',
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
                                      'Credit',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      'Rs ${transaction.credit.toStringAsFixed(2)}',
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
                                      'Balance',
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    Text(
                                      transaction.balance,
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
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalItem('Total Receipt',
                      controller.totalReceipt.value, TColor.secondary),
                  _buildTotalItem('Total Payment',
                      controller.totalPayment.value, TColor.third),
                  _buildTotalItem('Closing Balance',
                      controller.closingBalance.value, TColor.primary),
                ],
              )),
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}