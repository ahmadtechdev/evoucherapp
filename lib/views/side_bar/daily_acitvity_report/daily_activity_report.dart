import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:pdf/pdf.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'controller/daily_activity_controller.dart';

class DailyActivityReport extends StatelessWidget {
  final DailyActivityReportController controller = Get.put(DailyActivityReportController());

  DailyActivityReport({super.key});

  Future<void> _exportToPDF(BuildContext context) async {
    final pdf = pw.Document();

    // Load the logo
    final logoImage = await rootBundle.load('assets/img/logo.png');
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
              'Daily Activity Report',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Date: From ${controller.formatDate(controller.fromDate.value)} '
                  'To ${controller.formatDate(controller.toDate)}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['V#', 'Date', 'Account', 'Description', 'Debit', 'Credit'],
              ...controller.activities.map((activity) => [
                activity.voucherNo,
                controller.formatDate(activity.date),
                activity.account,
                activity.description,
                'Rs ${activity.debit.toStringAsFixed(2)}',
                'Rs ${activity.credit.toStringAsFixed(2)}',
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
                'Total Debit: Rs ${controller.activities.fold<double>(0, (sum, item) => sum + item.debit).toStringAsFixed(2)}',
              ),
              pw.Text(
                'Total Credit: Rs ${controller.activities.fold<double>(0, (sum, item) => sum + item.credit).toStringAsFixed(2)}',
              ),
              pw.Text(
                'Closing Balance: Rs ${(controller.activities.fold<double>(0, (sum, item) => sum + item.debit) - controller.activities.fold<double>(0, (sum, item) => sum + item.credit)).toStringAsFixed(2)}',
              ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Activity Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 4),
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
                        child: DateSelector2(
                          label: "From: ",
                          fontSize: 12,
                          initialDate: controller.fromDate.value,
                          onDateChanged: (date) {
                            controller.fromDate.value = date;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DateSelector2(
                          label: "To: ",
                          fontSize: 12,
                          initialDate: controller.toDate,
                          onDateChanged: (date) {
                            controller.toDate = date;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement Submit functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Submit'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _exportToPDF(context);
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.third,
                          foregroundColor: TColor.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Obx(() {
                      return Text(
                        'From ${DateFormat('E, dd MMM yyyy').format(controller.fromDate.value)} To ${DateFormat('E, dd MMM yyyy').format(controller.toDate)}',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.activities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.activities[index];
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
                        padding: const EdgeInsets.all(16),
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
                                    activity.voucherNo,
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.formatDate(activity.date),
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  activity.account,
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: TColor.third.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Debit',
                                            style: TextStyle(color: TColor.secondaryText),
                                          ),
                                          Text(
                                            'Rs ${activity.debit.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: TColor.third,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: TColor.secondary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Credit',
                                            style: TextStyle(color: TColor.secondaryText),
                                          ),
                                          Text(
                                            'Rs ${activity.credit.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: TColor.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity.description,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}