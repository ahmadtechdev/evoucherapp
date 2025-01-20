// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/snackbar.dart';
import '../../../../service/api_service.dart';
import '../models/recovery_list_modal_class.dart';
import 'package:pdf/widgets.dart' as pw;

class RecoveryListController extends GetxController {
  var recoveryList = <RecoveryListModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchRecoveryLists();
  }

  Future<void> fetchRecoveryLists() async {
    try {
      isLoading.value = true;

      // Get current date for the API request
      final now = DateTime.now();
      const fromDate = '2023-01-01'; // You can adjust this as needed
      final toDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _apiService.fetchDateRangeReport(
          endpoint: "recoveryLists", fromDate: fromDate, toDate: toDate);

      if ( response['status'] == 'success') {
        final List<dynamic> listsJson = response['data']['lists'];
        recoveryList.value =
            listsJson.map((json) => RecoveryListModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recovery lists');
      }
    } catch (e) {
      debugPrint('Error fetching recovery lists: $e');
      Get.snackbar(
        'Error',
        'Failed to load recovery lists',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<RecoveryListModel> get filteredList {
    if (searchQuery.value.isEmpty) {
      return recoveryList;
    }
    return recoveryList
        .where((item) =>
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
        build: (pw.Context context) => [
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
              ...(recoveryList.map((item) => [
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
                'Total Outstanding: \$${recoveryList.fold(0.0, (sum, item) => sum + item.remaining).toStringAsFixed(2)}',
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
          builder: (context) => AlertDialog(
            backgroundColor: TColor.white,
            title: Row(
              children: [
                Icon(Icons.check_circle, color: TColor.secondary, size: 28),
                const SizedBox(width: 8),
                Text(
                  'PDF Generated',
                  style: TextStyle(
                      color: TColor.primaryText, fontWeight: FontWeight.bold),
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
        CustomSnackBar(
            message: "Failed to generate PDF: $e",
            backgroundColor: TColor.third);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }
}
