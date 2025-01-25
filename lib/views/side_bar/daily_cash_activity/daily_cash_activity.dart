import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/daily_cash_controller.dart';
import 'models/daily_cash_activity_model.dart';

class DailyCashActivity extends StatelessWidget {
  const DailyCashActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final DailyCashActivityController controller =
    Get.put(DailyCashActivityController());

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Cash Activity'),
      ),
      drawer: const CustomDrawer(currentIndex: 5),
      body: Column(
        children: [
          _buildDateSelector(controller, context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadTransactions(),
              child: SingleChildScrollView(
                child: Obx(() {
                  // Show loading indicator while fetching data
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: TColor.primary,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Loading Transactions...',
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Show transactions when data is loaded
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateDisplay(controller),
                      _buildSummaryGrid(),
                      Obx(() => _buildSection('Cash Received', TColor.secondary,
                          controller.receivedTransactions)),
                      Obx(() => _buildSection('Cash Paid', TColor.third,
                          controller.paidTransactions)),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(
      DailyCashActivityController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: DateSelector2(
              label: "Select Date:",
              fontSize: 12,
              initialDate: controller.selectedDate.value,
              onDateChanged: (date) => controller.updateSelectedDate(date),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _exportToPDF(context),
            icon: const Icon(Icons.print, color: Colors.white),
            label: const Text('Print Report',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToPDF(BuildContext context) async {
    final DailyCashActivityController controller = Get.find();
    final pdf = pw.Document();

    // Load the logo
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
              'Daily Cash Book Report',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Date: ${DateFormat('E, dd MMM yyyy').format(controller.selectedDate.value)}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
          ],
        ),
        build: (context) => [
          // Cash Received Section
          pw.Text(
            'Cash Received',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['V#', 'Account', 'Description', 'Amount'],
              ...controller.receivedTransactions.map((transaction) => [
                transaction.vNumber,
                transaction.account,
                transaction.description,
                'Rs. ${transaction.amount}',
              ]),
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),

          // Cash Paid Section
          pw.Text(
            'Cash Paid',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['V#', 'Account', 'Description', 'Amount'],
              ...controller.paidTransactions.map((transaction) => [
                transaction.vNumber,
                transaction.account,
                transaction.description,
                'Rs. ${transaction.amount}',
              ]),
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),

          // Summary
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text('Opening Balance: ${controller.openingBalance.value}'),
              pw.Text(
                  'Total Cash Received: Rs. ${controller.totalReceivedAmount.value}'),
              pw.Text(
                  'Total Cash Paid: Rs. ${controller.totalPaidAmount.value}'),
              pw.Text(
                  'Closing Balance: ${controller.closingBalanceAmount.value}'),
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

  Widget _buildDateDisplay(DailyCashActivityController controller) {
    return Center(
      child: Obx(() {
        return Text(
            'Date: ${DateFormat('E, dd MMM yyyy').format(controller.selectedDate.value)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ));
      }),
    );
  }

  Widget _buildSummaryGrid() {
    final DailyCashActivityController controller =
    Get.put(DailyCashActivityController());
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildSummaryCard(
              'Opening Balance',
              controller.openingBalance.value,
              TColor.primary,
              Icons.account_balance),
          _buildSummaryCard(
              'Total Cash Received',
              'Rs. ${controller.totalReceivedAmount.value}',
              TColor.secondary,
              Icons.arrow_downward),
          _buildSummaryCard(
              'Total Cash Paid',
              'Rs. ${controller.totalPaidAmount.value}',
              TColor.third,
              Icons.arrow_upward),
          _buildSummaryCard(
              'Closing Balance',
              controller.closingBalanceAmount.value,
              TColor.fourth,
              Icons.account_balance_wallet),
        ],
      ),
    ));
  }

  Widget _buildSummaryCard(
      String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, Color color, List<DailyCashActivityModel> transactions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...transactions
              .map((transaction) => _buildTransactionCard(transaction, color)),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
      DailyCashActivityModel transaction, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.vNumber,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.account,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Rs. ${transaction.amount}',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              transaction.description,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}