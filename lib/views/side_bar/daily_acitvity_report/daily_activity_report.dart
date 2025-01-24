import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../common_widget/dart_selector2.dart';
import 'controller/daily_activity_controller.dart';

class DailyActivityReport extends StatelessWidget {
  final DailyActivityReportController controller =
      Get.put(DailyActivityReportController());

  DailyActivityReport({super.key});

  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final logoImage = await rootBundle.load('assets/img/newLogo.png');
      final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

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
                'Date: From ${controller.dateRangeFrom.value} To ${controller.dateRangeTo.value}',
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
                  'Account',
                  'Description',
                  'Debit',
                  'Credit'
                ],
                ...controller.activities.map((activity) => [
                      activity.voucherNumber,
                      activity.date,
                      activity.accountName,
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
                  'Total Debit: Rs ${controller.totalDebit.value.toStringAsFixed(2)}',
                ),
                pw.Text(
                  'Total Credit: Rs ${controller.totalCredit.value.toStringAsFixed(2)}',
                ),
                pw.Text(
                  'Balance: Rs ${controller.balance.value.toStringAsFixed(2)}',
                ),
              ],
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
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
      );
    }
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
                            controller.fetchDailyActivity();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DateSelector2(
                          label: "To: ",
                          fontSize: 12,
                          initialDate: controller.toDate.value,
                          onDateChanged: (date) {
                            controller.toDate.value = date;
                            controller.fetchDailyActivity();
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
                        onPressed: () => controller.fetchDailyActivity(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          foregroundColor: TColor.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Submit'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _exportToPDF(context),
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
                        'From ${DateFormat('E, dd MMM yyyy').format(controller.fromDate.value)} '
                        'To ${DateFormat('E, dd MMM yyyy').format(controller.toDate.value)}',
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
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: TColor.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading activities...',
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.activities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: TColor.secondaryText,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No activities found',
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your date range',
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchDailyActivity(),
                  child: ListView.builder(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TColor.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      activity.voucherNumber,
                                      style: TextStyle(
                                        color: TColor.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    activity.date,
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      activity.accountName,
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildAmountContainer(
                                        'Debit',
                                        activity.debit,
                                        TColor.third,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildAmountContainer(
                                        'Credit',
                                        activity.credit,
                                        TColor.secondary,
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
                  ),
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
              child: Obx(
                () => Row(
                  children: [
                    _buildTotalItem('Total Debit', controller.totalDebit.value,
                        TColor.third),
                    _buildTotalItem('Total Credit',
                        controller.totalCredit.value, TColor.secondary),
                    _buildTotalItem(
                        'Balance', controller.balance.value, TColor.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountContainer(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: TColor.secondaryText),
          ),
          Text(
            'Rs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
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
          'Rs ${amount.toStringAsFixed(0)}',
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
