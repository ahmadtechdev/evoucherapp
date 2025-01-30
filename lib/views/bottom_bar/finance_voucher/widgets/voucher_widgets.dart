// voucher_widgets.dart

import 'package:evoucher_new/views/bottom_bar/finance_voucher/bank/view_edit_b_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/snackbar.dart';
import '../cash/view_edit_c_voucher.dart';
import '../expense/view_edit_e_voucher.dart';
import '../journal/view_edit_j_voucher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class EntryVoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;
  final String type;
  final Function(Map<String, dynamic>)? onVoucherTap;

  const EntryVoucherCard({
    super.key,
    required this.voucher,
    required this.type,
    this.onVoucherTap,
  });

  Future<void> printVoucher(BuildContext context) async {
    final pdf = pw.Document();

    // Load the logo
    final logoImage = await rootBundle.load('assets/img/newLogo.png');
    final logo = pw.MemoryImage(logoImage.buffer.asUint8List());

    // Format details data
    final details = (voucher['originalData']['details'] as List<dynamic>? ?? []);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logo, width: 100, height: 50),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Journey Online',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Address Line 1, City',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.Text(
                          'Phone: +1234567890',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Voucher Title
                pw.Center(
                  child: pw.Text(
                    '${type.toUpperCase()} VOUCHER',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Voucher Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Voucher #: ${voucher['id']}'),
                    pw.Text('Date: ${voucher['date']}'),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text('Description: ${voucher['description']}'),
                pw.SizedBox(height: 20),

                // Table Header
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(4),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Table Header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Account',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Description',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Debit',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Credit',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Table Rows
                    ...details.map((detail) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(detail['account_name'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(detail['description'] ?? ''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            detail['debit'] ?? '0.00',
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            detail['credit'] ?? '0.00',
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Totals
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Total: ${voucher['amount']}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Signatures
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(top: pw.BorderSide()),
                          ),
                        ),
                        pw.Text('Prepared By'),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(top: pw.BorderSide()),
                          ),
                        ),
                        pw.Text('Approved By'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }


  void _handleViewPress() {
    // Create the properly structured data for the detail view
    final formattedVoucherData = {
      'master': {
        'voucher_id': voucher['id'],
        'voucher_data': voucher['date'],
        'num_entries': voucher['entries'],
        'total_debit': voucher['debit'] ?? '0.000',
        'total_credit': voucher['credit'] ?? '0.000',
        'added_by': voucher['addedBy']
      },
      'details': (voucher['originalData']['details'] as List<dynamic>? ?? [])
          .map((entry) => {
                'voucher_id': voucher['id'],
                'account_id': entry['account_id'] ?? '',
                'account_name': entry['account_name'] ?? '',
                'description': entry['description'] ?? '',
                'debit': entry['debit'] ?? '0.00',
                'credit': entry['credit'] ?? '0.00'
              })
          .toList()
    };

    switch (type) {
      case 'journal':
        Get.to(() => JournalVoucherDetail(voucherData: formattedVoucherData));
        break;
      case 'cash':
        Get.to(() => CashVoucherDetail(voucherData: formattedVoucherData));
        break;
      case 'expense':
        Get.to(() => ExpenseVoucherDetail(voucherData: formattedVoucherData));
        break;
      case 'bank':
        Get.to(() => BankVoucherDetail(voucherData: formattedVoucherData));
        break;
      default:
        Get.to(() => JournalVoucherDetail(voucherData: formattedVoucherData));
    }

    // Call onVoucherTap if provided
    onVoucherTap?.call(voucher);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  voucher['id'],
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  voucher['date'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              voucher['description'],
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added by: ${voucher['addedBy']}',
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entries: ${voucher['entries']}',
                  style: TextStyle(
                    color: TColor.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  voucher['amount'],
                  style: TextStyle(
                    color: TColor.fourth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  // onPressed: () {
                  //   Get.to(() => JournalVoucherDetail(voucherData: voucher));
                  // },
                  onPressed: _handleViewPress,
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColor.primary,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => printVoucher(context),
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColor.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EntryVoucherListView extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers;
  final String type;

  final Function(Map<String, dynamic>)? onVoucherTap;

  const EntryVoucherListView({
    super.key,
    required this.vouchers,
    required this.type,
    this.onVoucherTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return EntryVoucherCard(
          voucher: vouchers[index],
          type: type,
          onVoucherTap: onVoucherTap,
        );
      },
    );
  }
}

class UnPostedVoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;

  const UnPostedVoucherCard({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher['id'],
                        style: TextStyle(
                          color: TColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      voucher['date'],
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                voucher['description'],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: TColor.fourth,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          voucher['addedBy'] != null &&
                                  voucher['addedBy'].isNotEmpty
                              ? voucher['addedBy']
                              : 'Unknown',
                          style: TextStyle(
                            color: TColor.fourth,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.format_list_numbered,
                          size: 16,
                          color: TColor.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${voucher['entries']} Entries',
                          style: TextStyle(
                            color: TColor.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // View Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Get.to(() => const ViewUnPostedVouchers());
                    CustomSnackBar(message: "this feature currently unavailable on mobile. ", backgroundColor: TColor.fourth).show();

                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: TColor.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UnPostedVoucherListView extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers;

  const UnPostedVoucherListView({
    super.key,
    required this.vouchers,
    required Null Function(dynamic voucher) onVoucherTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return UnPostedVoucherCard(voucher: vouchers[index]);
      },
    );
  }
}
