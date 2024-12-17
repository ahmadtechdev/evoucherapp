
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/snackbar.dart';
import '../models/recovery_list_modal_class.dart';
import 'package:pdf/widgets.dart' as pw;

class RecoveryListController extends GetxController {
  var recoveryList = <RecoveryListModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    recoveryList.addAll([
      RecoveryListModel(rlName: 'Ali Ameen',
          dateCreated: 'Fri, 23 Feb 2024',
          totalAmount: 250000.00,
          received: 150000.00,
          remaining: 100000.00),
      // Add other items...
      RecoveryListModel(
        rlName: 'Vendors',
        dateCreated: 'Mon, 11 Sep 2023',
        totalAmount: 142000.00,
        received: 10000.00,
        remaining: 132000.00,
      ),
      RecoveryListModel(
        rlName: 'John Doe',
        dateCreated: 'Wed, 15 Mar 2023',
        totalAmount: 120000.00,
        received: 80000.00,
        remaining: 40000.00,
      ),
      RecoveryListModel(
        rlName: 'Jane Smith',
        dateCreated: 'Thu, 10 Aug 2023',
        totalAmount: 180000.00,
        received: 100000.00,
        remaining: 80000.00,
      ),
      RecoveryListModel(
        rlName: 'ABC Corp',
        dateCreated: 'Tue, 02 May 2023',
        totalAmount: 300000.00,
        received: 250000.00,
        remaining: 50000.00,
      ),
      RecoveryListModel(
        rlName: 'XYZ Pvt Ltd',
        dateCreated: 'Fri, 22 Sep 2023',
        totalAmount: 220000.00,
        received: 170000.00,
        remaining: 50000.00,
      ),
      RecoveryListModel(
        rlName: 'Mike Ross',
        dateCreated: 'Mon, 06 Nov 2023',
        totalAmount: 50000.00,
        received: 20000.00,
        remaining: 30000.00,
      ),
      RecoveryListModel(
        rlName: 'Harvey Specter',
        dateCreated: 'Sat, 18 Feb 2024',
        totalAmount: 80000.00,
        received: 60000.00,
        remaining: 20000.00,
      ),
      RecoveryListModel(
        rlName: 'Rachel Zane',
        dateCreated: 'Wed, 12 Jul 2023',
        totalAmount: 150000.00,
        received: 75000.00,
        remaining: 75000.00,
      ),
      RecoveryListModel(
        rlName: 'Donna Paulsen',
        dateCreated: 'Sun, 01 Oct 2023',
        totalAmount: 95000.00,
        received: 45000.00,
        remaining: 50000.00,
      ),
      RecoveryListModel(
        rlName: 'Louis Litt',
        dateCreated: 'Fri, 29 Sep 2023',
        totalAmount: 75000.00,
        received: 25000.00,
        remaining: 50000.00,
      ),
      RecoveryListModel(
        rlName: 'Pearson Hardman',
        dateCreated: 'Tue, 08 Aug 2023',
        totalAmount: 120000.00,
        received: 50000.00,
        remaining: 70000.00,
      ),
      RecoveryListModel(
        rlName: 'Global Ventures',
        dateCreated: 'Thu, 25 May 2023',
        totalAmount: 200000.00,
        received: 100000.00,
        remaining: 100000.00,
      ),
      RecoveryListModel(
        rlName: 'Tech Solutions',
        dateCreated: 'Mon, 20 Mar 2023',
        totalAmount: 170000.00,
        received: 120000.00,
        remaining: 50000.00,
      ),
      RecoveryListModel(
        rlName: 'Innovate Ltd',
        dateCreated: 'Fri, 10 Nov 2023',
        totalAmount: 240000.00,
        received: 200000.00,
        remaining: 40000.00,
      ),
      RecoveryListModel(
        rlName: 'Prime Traders',
        dateCreated: 'Wed, 16 Aug 2023',
        totalAmount: 190000.00,
        received: 90000.00,
        remaining: 100000.00,
      ),
      RecoveryListModel(
        rlName: 'Smart Industries',
        dateCreated: 'Sat, 30 Sep 2023',
        totalAmount: 130000.00,
        received: 70000.00,
        remaining: 60000.00,
      ),
      RecoveryListModel(
        rlName: 'Future Corp',
        dateCreated: 'Tue, 14 Feb 2023',
        totalAmount: 220000.00,
        received: 180000.00,
        remaining: 40000.00,
      ),
      RecoveryListModel(
        rlName: 'Elite Group',
        dateCreated: 'Thu, 22 Jun 2023',
        totalAmount: 160000.00,
        received: 80000.00,
        remaining: 80000.00,
      ),
      RecoveryListModel(
        rlName: 'Pioneer Inc',
        dateCreated: 'Sun, 05 Mar 2023',
        totalAmount: 145000.00,
        received: 45000.00,
        remaining: 100000.00,
      ),
    ]);
  }

  List<RecoveryListModel> get filteredList {
    if (searchQuery.value.isEmpty) {
      return recoveryList;
    }
    return recoveryList.where((item) =>
        item.rlName.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void addRecoveryItem(RecoveryListModel item) {
    recoveryList.add(item);
  }

  void updateRecoveryItem(int index, RecoveryListModel item) {
    recoveryList[index] = item;
  }

  void deleteRecoveryItem(int index) {
    recoveryList.removeAt(index);
  }

  Future<void> exportToPDF(BuildContext context) async {
    // Implement PDF generation logic here (similar to provided function)
    // Use pdf package to create the PDF
    final pdf = pw.Document();

    // Load the logo
    final logoImage = await rootBundle.load('assets/img/logo.png');
    final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        header: (pw.Context context) {
          return pw.Column(
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
                'Recovery List Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Generated on: ${DateTime.now().toLocal()}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
        build: (pw.Context context) =>
        [
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>[
                'Name',
                'Date Created',
                'Total Amount',
                'Received',
                'Remaining'
              ],
              ...(recoveryList.map((item) =>
              [
                item.rlName,
                item.dateCreated,
                '\$${item.totalAmount.toStringAsFixed(2)}',
                '\$${item.received.toStringAsFixed(2)}',
                '\$${item.remaining.toStringAsFixed(2)}',
              ])),
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
                'Total Entries: ${recoveryList.length}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Total Outstanding: \$${recoveryList.fold(
                    0.0, (sum, item) => sum + item.remaining).toStringAsFixed(
                    2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

    // Save PDF to downloads folder
    try {
      // Save PDF to downloads folder
      try {
        // Save and print the PDF
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
        // Show preview and save confirmation
        await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                backgroundColor: TColor.white,
                title: Row(
                  children: [
                    Icon(Icons.check_circle, color: TColor.secondary, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'PDF Generated',
                      style: TextStyle(color: TColor.primaryText,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your PDF has been successfully generated',
                      style: TextStyle(color: TColor.secondaryText),
                    ),

                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close', style: TextStyle(color: TColor.third)),
                  ),

                ],
              ),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously

        CustomSnackBar(
            message: "Failed to generate PDF: $e",
            backgroundColor: TColor.third
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }
}