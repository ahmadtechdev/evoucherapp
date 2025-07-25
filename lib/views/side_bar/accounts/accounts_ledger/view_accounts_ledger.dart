import 'dart:io';

import 'package:evoucher_new/common_widget/snackbar.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/color_extension.dart';
import '../../../../common_widget/dart_selector2.dart';
import '../../../../common_widget/round_text_field.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'controller/ledger_controller.dart';
import 'models/ledger_modal.dart';
import 'package:flutter/material.dart';

class LedgerScreen extends StatelessWidget {
  final String accountId;
  final String accountName;

  const LedgerScreen({
    super.key,
    required this.accountId,
    required this.accountName,
  });

  Future<void> _exportToPDF(
      BuildContext context, LedgerController controller) async {
    final pdf = pw.Document();

    try {
      // Load the logo
      final ByteData logoData = await rootBundle.load('assets/img/newLogo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final logo = pw.MemoryImage(logoBytes);

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
                'Account Ledger Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Account: ${controller.accountName} (${controller.accountId})',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Period: ${DateFormat('dd-MMM-yyyy').format(controller.fromDate.value)} to ${DateFormat('dd-MMM-yyyy').format(controller.toDate.value)}',
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
                  'Voucher',
                  'Date',
                  'Description',
                  'Debit',
                  'Credit',
                  'Balance'
                ],
                ...controller.filteredVouchers.map((voucher) => [
                      voucher.voucher,
                      DateFormat('dd-MMM-yyyy')
                          .format(DateTime.parse(voucher.date)),
                      voucher.description,
                      voucher.debit.toStringAsFixed(2),
                      voucher.credit.toStringAsFixed(2),
                      voucher.balance,
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
                  'Total Debit: ${NumberFormat('#,##0.00').format(controller.calculateTotalDebit())}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Total Credit: ${NumberFormat('#,##0.00').format(controller.calculateTotalCredit())}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Closing Balance: ${controller.masterData.value?.closing ?? ""}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      );

      // Show the PDF print preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      CustomSnackBar(
          message: 'Error generating PDF: $e', backgroundColor: TColor.third);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with dependency injection
    final LedgerController controller = Get.put(
        LedgerController(accountId: accountId, accountName: accountName));

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }

        if (controller.masterData.value == null) {
          return const Center(child: Text('No data available'));
        }

        final masterData = controller.masterData.value!;
        final vouchers = controller.filteredVouchers;

        // Calculate totals
        double totalDebit = controller.calculateTotalDebit();
        double totalCredit = controller.calculateTotalCredit();

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildDateRangeSection(controller),
              _buildActionButtons(context, controller),
              Text(
                'FROM: ${DateFormat('EEE, dd-MMM-yyyy').format(controller.fromDate.value)} | TO: ${DateFormat('EEE, dd-MMM-yyyy').format(controller.toDate.value)}',
                style: TextStyle(
                  fontSize: 12,
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Opening Balance ${masterData.opening}',
                style: TextStyle(
                  fontSize: 12,
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SearchTextField(
                hintText: 'Search transactions...',
                onChange: controller.searchTransactions,
              ),
              _buildTransactionList(vouchers),
              _buildSummaryCard(totalDebit, totalCredit, masterData.closing),
              _buildSummaryDetails(masterData),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          'Ledger of $accountId | $accountName',
          style: TextStyle(color: TColor.white),
        ),
      ),
      backgroundColor: TColor.primary,
      foregroundColor: TColor.white,
      elevation: 0.5,
    );
  }

  Widget _buildDateRangeSection(LedgerController controller) {
    return Container(
      color: TColor.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink-wraps the row content
        children: [
          const SizedBox(width: 18),
          Flexible(
            child: DateSelector2(
              fontSize: 14,
              initialDate: controller.fromDate.value,
              onDateChanged: (date) {
                controller.updateDateRange(date, controller.toDate.value);
              },
              label: "FROM:",
            ),
          ),
          const SizedBox(width: 18),
          Flexible(
            child: DateSelector2(
              fontSize: 14,
              initialDate: controller.toDate.value,
              onDateChanged: (date) {
                controller.updateDateRange(controller.fromDate.value, date);
              },
              label: "TO:",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, LedgerController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Row(
        children: [
          _buildActionButton(MdiIcons.microsoftExcel, 'Excel', TColor.primary,
              () => _exportToExcel(context, controller.filteredVouchers)),
          _buildActionButton(MdiIcons.printer, 'Print', TColor.third,
              () => _exportToPDF(context, controller)),
          _buildActionButton(MdiIcons.whatsapp, 'Whatsapp', TColor.secondary,
              launchWhatsappWithMobileNumber),
        ],
      ),
    );
  }

  Future<void> _exportToExcel(
      BuildContext context, List<LedgerVoucher> vouchers) async {
    try {
      // Request storage permissions (for Android 13+)
      bool isPermissionGranted = await _requestStoragePermission(context);
      if (!isPermissionGranted) {
        return; // Exit if permission is not granted
      }

      // Create a new Excel file
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Add headers
      sheet.appendRow([
        TextCellValue('Voucher'),
        TextCellValue('Date'),
        TextCellValue('Description'),
        TextCellValue('Debit'),
        TextCellValue('Credit'),
        TextCellValue('Balance'),
      ]);

      // Add voucher data
      for (var voucher in vouchers) {
        sheet.appendRow([
          TextCellValue(voucher.voucher),
          TextCellValue(voucher.date),
          TextCellValue(voucher.description),
          DoubleCellValue(voucher.debit),
          DoubleCellValue(voucher.credit),
          TextCellValue(voucher.balance),
        ]);
      }

      // Get the path to the app's download directory
      String downloadsPath = '/storage/emulated/0/Download';
      String filePath =
          '$downloadsPath/ledger${DateTime.now().millisecondsSinceEpoch}.xlsx';

      // Save the Excel file
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        // Show success message

        CustomSnackBar(
                message: 'Excel file exported to $filePath',
                backgroundColor: TColor.secondary)
            .show();
      } else {
        CustomSnackBar(
                message: 'Failed to export Excel file',
                backgroundColor: TColor.third)
            .show();
      }
    } catch (e) {
      // Handle exceptions

      CustomSnackBar(
              message: 'Error: ${e.toString()}', backgroundColor: TColor.third)
          .show();
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
        // ignore: use_build_context_synchronously
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

  Future<void> launchWhatsappWithMobileNumber() async {
    String message = "Journey Online Message";
    String mobileNumber = "923100007901";
    final url = "https://wa.me/$mobileNumber?text=$message";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildTransactionList(List<LedgerVoucher> vouchers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) => _buildTransactionCard(vouchers[index]),
    );
  }

  Widget _buildTransactionCard(LedgerVoucher voucher) {
    return Card(
      margin: const EdgeInsets.only(bottom: 2),
      elevation: 3,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTransactionDetails(voucher),
            _buildTransactionAmounts(voucher),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(LedgerVoucher voucher) {
    bool isCredit = voucher.balance.toLowerCase().contains('cr');

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  voucher.voucher,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: TColor.secondaryText, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(voucher.date)),
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              voucher.description,
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: TColor.primary, size: 20),
                const SizedBox(width: 4),
                Text(
                  voucher.balance,
                  style: TextStyle(
                    color: isCredit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionAmounts(LedgerVoucher voucher) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          _buildAmountBox('Debit', voucher.debit),
          const SizedBox(height: 6),
          _buildAmountBox('Credit', voucher.credit),
        ],
      ),
    );
  }

  Widget _buildAmountBox(String label, num amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: TColor.secondaryText, fontSize: 10),
          ),
          Text(
            ' ${NumberFormat('#,##0.00').format(amount)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      double totalDebit, double totalCredit, String closing) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalColumn('Total Debit', totalDebit.toString(),
                      Icons.arrow_downward, TColor.third),
                  const SizedBox(width: 20),
                  _buildTotalColumn('Total Credit', totalCredit.toString(),
                      Icons.arrow_upward, TColor.secondary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalColumn('Closing Balance', closing.toString(),
                      Icons.account_balance_wallet, TColor.primary,
                      isHighlighted: true),
                  const SizedBox(width: 20),
                  _buildWOAccountButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalColumn(
      String label, String value, IconData icon, Color iconColor,
      {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(color: TColor.secondaryText, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: isHighlighted ? TColor.primary : TColor.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWOAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.account_balance,
          size: 10,
        ),
        label: const Text(
          'W/O Account Now',
          style: TextStyle(fontSize: 10),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: TColor.third,
          foregroundColor: TColor.white,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSummaryDetails(LedgerMasterData masterData) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: TColor.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Summary of Ledger Adam',
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              const Divider(height: 1),
              _buildSummaryRow(Icons.account_balance, TColor.primary,
                  'Opening Balance B/F', masterData.opening),
              _buildSummaryRow(Icons.add_circle, Colors.green,
                  'Add Sale Invoice', 'PKR 0 -d'),
              _buildSummaryRow(Icons.remove_circle, Colors.red,
                  'Less Refund Invoices', 'PKR 0 -d'),
              _buildSummaryRow(
                  Icons.remove_circle, Colors.red, 'Less Receipts', 'PKR 0 -d'),
              _buildSummaryRow(
                  Icons.add_circle, Colors.green, 'Add Payments', 'PKR 0 -d'),
              const Divider(height: 1),
              _buildSummaryRow(Icons.account_balance_wallet, TColor.primary,
                  'Net Balance', masterData.opening,
                  isTotal: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      IconData icon, Color iconColor, String label, String value,
      {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTotal ? TColor.primary.withOpacity(0.05) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Text(
            value,
            style: TextStyle(
                color: isTotal ? TColor.primary : TColor.primaryText,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: color),
    );
  }
// Rest of the methods remain the same as in the original file
// _buildTransactionList, _buildTransactionCard, _buildSummaryCard, etc.
// Refer to the original file for their implementation
}
