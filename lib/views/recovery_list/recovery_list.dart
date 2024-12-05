import 'dart:io';

import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:evoucher/common_widget/round_textfield.dart';
import 'package:evoucher/views/recovery_list/recovery_list_card.dart';
import 'package:evoucher/views/recovery_list/recovery_list_modal_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import 'pdf_preview.dart';

class RecoveryListsScreen extends StatefulWidget {
  const RecoveryListsScreen({super.key});

  @override
  RecoveryListsScreenState createState() => RecoveryListsScreenState();
}

class RecoveryListsScreenState extends State<RecoveryListsScreen> {
  List<RecoveryListItem> _recoveryList = [
    RecoveryListItem(
      rlName: 'Ali Ameen',
      dateCreated: 'Fri, 23 Feb 2024',
      totalAmount: 250000.00,
      received: 150000.00,
      remaining: 100000.00,
    ),
    RecoveryListItem(
      rlName: 'Vendors',
      dateCreated: 'Mon, 11 Sep 2023',
      totalAmount: 142000.00,
      received: 10000.00,
      remaining: 132000.00,
    ),
    RecoveryListItem(
      rlName: 'John Doe',
      dateCreated: 'Wed, 15 Mar 2023',
      totalAmount: 120000.00,
      received: 80000.00,
      remaining: 40000.00,
    ),
    RecoveryListItem(
      rlName: 'Jane Smith',
      dateCreated: 'Thu, 10 Aug 2023',
      totalAmount: 180000.00,
      received: 100000.00,
      remaining: 80000.00,
    ),
    RecoveryListItem(
      rlName: 'ABC Corp',
      dateCreated: 'Tue, 02 May 2023',
      totalAmount: 300000.00,
      received: 250000.00,
      remaining: 50000.00,
    ),
    RecoveryListItem(
      rlName: 'XYZ Pvt Ltd',
      dateCreated: 'Fri, 22 Sep 2023',
      totalAmount: 220000.00,
      received: 170000.00,
      remaining: 50000.00,
    ),
    RecoveryListItem(
      rlName: 'Mike Ross',
      dateCreated: 'Mon, 06 Nov 2023',
      totalAmount: 50000.00,
      received: 20000.00,
      remaining: 30000.00,
    ),
    RecoveryListItem(
      rlName: 'Harvey Specter',
      dateCreated: 'Sat, 18 Feb 2024',
      totalAmount: 80000.00,
      received: 60000.00,
      remaining: 20000.00,
    ),
    RecoveryListItem(
      rlName: 'Rachel Zane',
      dateCreated: 'Wed, 12 Jul 2023',
      totalAmount: 150000.00,
      received: 75000.00,
      remaining: 75000.00,
    ),
    RecoveryListItem(
      rlName: 'Donna Paulsen',
      dateCreated: 'Sun, 01 Oct 2023',
      totalAmount: 95000.00,
      received: 45000.00,
      remaining: 50000.00,
    ),
    RecoveryListItem(
      rlName: 'Louis Litt',
      dateCreated: 'Fri, 29 Sep 2023',
      totalAmount: 75000.00,
      received: 25000.00,
      remaining: 50000.00,
    ),
    RecoveryListItem(
      rlName: 'Pearson Hardman',
      dateCreated: 'Tue, 08 Aug 2023',
      totalAmount: 120000.00,
      received: 50000.00,
      remaining: 70000.00,
    ),
    RecoveryListItem(
      rlName: 'Global Ventures',
      dateCreated: 'Thu, 25 May 2023',
      totalAmount: 200000.00,
      received: 100000.00,
      remaining: 100000.00,
    ),
    RecoveryListItem(
      rlName: 'Tech Solutions',
      dateCreated: 'Mon, 20 Mar 2023',
      totalAmount: 170000.00,
      received: 120000.00,
      remaining: 50000.00,
    ),
    RecoveryListItem(
      rlName: 'Innovate Ltd',
      dateCreated: 'Fri, 10 Nov 2023',
      totalAmount: 240000.00,
      received: 200000.00,
      remaining: 40000.00,
    ),
    RecoveryListItem(
      rlName: 'Prime Traders',
      dateCreated: 'Wed, 16 Aug 2023',
      totalAmount: 190000.00,
      received: 90000.00,
      remaining: 100000.00,
    ),
    RecoveryListItem(
      rlName: 'Smart Industries',
      dateCreated: 'Sat, 30 Sep 2023',
      totalAmount: 130000.00,
      received: 70000.00,
      remaining: 60000.00,
    ),
    RecoveryListItem(
      rlName: 'Future Corp',
      dateCreated: 'Tue, 14 Feb 2023',
      totalAmount: 220000.00,
      received: 180000.00,
      remaining: 40000.00,
    ),
    RecoveryListItem(
      rlName: 'Elite Group',
      dateCreated: 'Thu, 22 Jun 2023',
      totalAmount: 160000.00,
      received: 80000.00,
      remaining: 80000.00,
    ),
    RecoveryListItem(
      rlName: 'Pioneer Inc',
      dateCreated: 'Sun, 05 Mar 2023',
      totalAmount: 145000.00,
      received: 45000.00,
      remaining: 100000.00,
    ),
  ];

  void _previewPDF(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFPreviewScreen(pdfFile: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Recovery List'),
      ),
      drawer: const CustomDrawer(currentIndex: 10),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchTextField(
              hintText: "Search..",
              onChange: (value) {
                setState(() {
                  _recoveryList = _filterRecoveryList(value);
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _recoveryList.length,
                itemBuilder: (context, index) {
                  final item = _recoveryList[index];
                  return RecoveryListCard(
                    rlName: item.rlName,
                    dateCreated: item.dateCreated,
                    totalAmount: item.totalAmount,
                    received: item.received,
                    remaining: item.remaining,
                    onDetailsPressed: () {
                      _showDetailsDialog(context, item);
                    },
                    onUpdatePressed: () {
                      _showAddEditDialog(context,
                          existingItem: item, index: index);
                    },
                    onDeletePressed: () {
                      _deleteItem(index);
                    },
                    onGetPdfPressed: () async {
                      // Handle Get PDF action
                      final pdf = pw.Document();

                      // Load the logo
                      final logoImage =
                          await rootBundle.load('assets/img/logo.png');
                      final logo =
                          pw.MemoryImage(logoImage.buffer.asUint8List());

                      pdf.addPage(
                        pw.MultiPage(
                          header: (pw.Context context) {
                            return pw.Column(
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
                                  'Recovery List Details',
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                          build: (pw.Context context) => [
                            pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FlexColumnWidth(1),
                                1: const pw.FlexColumnWidth(1),
                                2: const pw.FlexColumnWidth(1),
                                3: const pw.FlexColumnWidth(1),
                                4: const pw.FlexColumnWidth(1),
                              },
                              children: [
                                pw.TableRow(
                                  decoration:  pw.BoxDecoration(
                                      color: PdfColors.grey300,

                                  ),
                                  children: [
                                    pw.Text('Name',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text('Date Created',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text('Total Amount',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text('Received',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.Text('Remaining',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Text(item.rlName),
                                    pw.Text(item.dateCreated),
                                    pw.Text(
                                        '\$${item.totalAmount.toStringAsFixed(2)}'),
                                    pw.Text(
                                        '\$${item.received.toStringAsFixed(2)}'),
                                    pw.Text(
                                        '\$${item.remaining.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );

                      // Save PDF to downloads folder
                      try {
                        final output = await getExternalStorageDirectory();
                        final file = File(
                            '${output?.path}/recovery_list_${DateTime.now().millisecondsSinceEpoch}.pdf');
                        await file.writeAsBytes(await pdf.save());

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
                                  style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your PDF has been successfully generated and saved at the following location:',
                                  style: TextStyle(color: TColor.secondaryText),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  file.path,
                                  style: TextStyle(color: TColor.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close', style: TextStyle(color: TColor.primary)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _previewPDF(File(file.path)); // Implement this preview method
                                },
                                child: Text('Preview', style: TextStyle(color: TColor.secondary)),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to generate PDF: $e')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, RecoveryListItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          title: Text(
            'Recovery List Details',
            style: TextStyle(
              color: TColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', item.rlName),
              _buildDetailRow('Date Created', item.dateCreated),
              _buildDetailRow(
                  'Total Amount', '\$${item.totalAmount.toStringAsFixed(2)}'),
              _buildDetailRow(
                  'Received', '\$${item.received.toStringAsFixed(2)}'),
              _buildDetailRow(
                  'Remaining', '\$${item.remaining.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: TColor.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context,
      {RecoveryListItem? existingItem, int? index}) {
    final nameController =
        TextEditingController(text: existingItem?.rlName ?? '');
    var dateController =
        TextEditingController(text: existingItem?.dateCreated ?? '');
    final totalAmountController = TextEditingController(
        text: existingItem?.totalAmount.toStringAsFixed(2) ?? '');
    final receivedController = TextEditingController(
        text: existingItem?.received.toStringAsFixed(2) ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 10,
          backgroundColor: TColor.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existingItem == null
                        ? 'Add Recovery List'
                        : 'Edit Recovery List',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Account Name TextField
                  RoundTextfield(
                    hintText: "Account Name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),

                  // Date Selector
                  DateSelector(
                    fontSize: 12,
                    initialDate: DateTime.now(),
                    onDateChanged: (date) {
                      dateController = date as TextEditingController;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Total Amount TextField
                  RoundTextfield(
                    hintText: "Total Amount",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: totalAmountController,
                  ),
                  const SizedBox(height: 12),

                  // Received Amount TextField
                  RoundTextfield(
                    hintText: "Received Amount",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: receivedController,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: TColor.third,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate and save the item
                          final newItem = RecoveryListItem(
                            rlName: nameController.text,
                            dateCreated: dateController.text,
                            totalAmount:
                                double.parse(totalAmountController.text),
                            received: double.parse(receivedController.text),
                            remaining:
                                double.parse(totalAmountController.text) -
                                    double.parse(receivedController.text),
                          );

                          setState(() {
                            if (existingItem == null) {
                              // Add new item
                              _recoveryList.add(newItem);
                            } else {
                              // Update existing item
                              _recoveryList[index!] = newItem;
                            }
                          });

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.secondary,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _recoveryList.removeAt(index);
    });
  }

  List<RecoveryListItem> _filterRecoveryList(String query) {
    return _recoveryList
        .where(
            (item) => item.rlName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
