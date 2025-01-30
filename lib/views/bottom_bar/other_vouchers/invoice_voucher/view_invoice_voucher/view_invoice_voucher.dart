import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/snackbar.dart';
import 'package:evoucher_new/service/api_service.dart';
import 'package:evoucher_new/views/bottom_bar/other_vouchers/invoice_voucher/view_invoice_voucher/invoice_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class ViewInvoiceVoucher extends StatelessWidget {
  final InvoiceVoucherController controller =
      Get.put(InvoiceVoucherController());

  ViewInvoiceVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Invoice Vouchers'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: TColor.textField),
                  ),
                );
              }

              if (controller.ticketVouchers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 60,
                        color: TColor.secondaryText.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Records Found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColor.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'There are no Invoice vouchers in this date range',
                        style: TextStyle(
                          fontSize: 14,
                          color: TColor.secondaryText.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.ticketVouchers.length,
                itemBuilder: (context, index) {
                  var ticket = controller.ticketVouchers[index];
                  return _buildVoucherCard(ticket, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Update the _buildVoucherCard method to handle the new data structure
  Widget _buildVoucherCard(Map<String, dynamic> ticket, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number, color: TColor.primary),
                const SizedBox(width: 10),
                Text(
                  ticket['VV_ID'],
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  ticket['date'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: TColor.primary),
                  onPressed: () {
                    CustomSnackBar(
                      message:
                          "This functionality is currently under development and will be available soon.",
                      backgroundColor: TColor.fourth,
                    ).show();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.calendar_today, 'Date', ticket['date']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.account_balance_wallet, 'Debit Account',
                    ticket['debit_account']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.account_balance, 'Credit Account',
                    ticket['credit_account']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person_add, 'Added by', ticket['added_by']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.format_list_numbered, 'Entries Count',
                    ticket['entries_count']),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Invoice',
                        Icons.receipt,
                        onPressed: () {
                          CustomSnackBar(
                                  message:
                                      "This functionality is currently under development and will be available soon.",
                                  backgroundColor: TColor.fourth)
                              .show();
                          // generateAndPreviewInvoice(
                          //   context,
                          //   ticket['VV_ID'].split(
                          //       ' ')[1],
                          //        // Extract ID number from "VV 841"
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: TColor.secondaryText),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon,
      {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TColor.primary.withOpacity(0.05),
        foregroundColor: TColor.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generateAndPreviewInvoice(
      BuildContext context, String voucherId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Fetch invoice data from API
      final response = await Get.put(ApiService()).postRequest(
        endpoint: 'getVisaVoucherInvoice',
        body: {'voucher_id': voucherId},
      );

      // Close loading dialog
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (response['status'] != 'success') {
        throw Exception('Failed to fetch invoice data');
      }

      final data = response['data'];

      // Create PDF document
      final doc = pw.Document();

      // Load logo from assets
      final logoImage = await rootBundle.load('assets/img/logo1.png');
      final logoImageData = logoImage.buffer.asUint8List();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(
                'Developed by Journeyonline.pk | CTC # 0310 0007901',
                style:
                    pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
              ),
            );
          },
          build: (pw.Context context) => [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo and company info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Image(pw.MemoryImage(logoImageData), width: 120),
                          pw.Text(data['company_info']['address'],
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                  text: 'CELL : ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.TextSpan(
                                  text: data['company_info']['cell'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10),
                                ),
                                pw.TextSpan(
                                  text: ' - PHONE : ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                pw.TextSpan(
                                  text: data['company_info']['phone'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ]),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(width: 2),
                          ),
                          child: pw.Column(children: [
                            pw.Text('Invoice'),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                '(PKR) = ${data['financial_info']['selling_price']}'),
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 20),

                // Invoice details table
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(1),
                  },
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    _buildTableRow(
                      ['Visa Invoice Date', 'Account Name'],
                      isHeader: true,
                      fontSize: 10,
                    ),
                    _buildTableRow(
                      [
                        data['voucher_info']['invoice_date'],
                        '${data['account_info']['name']} | ${data['account_info']['cell']}',
                      ],
                      fontSize: 10,
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Passenger details table
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                  },
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    _buildTableRow(
                      [
                        'Pax Name',
                        'Passport No.',
                        'V. Type #',
                        'Country',
                        'Amount (PKR)'
                      ],
                      isHeader: true,
                      fontSize: 10,
                    ),
                    _buildTableRow(
                      [
                        data['applicant_info']['name'],
                        data['applicant_info']['passport_details'],
                        data['visa_info']['visa_type'],
                        data['visa_info']['destination'],
                        data['financial_info']['selling_price'],
                      ],
                      fontSize: 10,
                    ),
                    _buildTableRow(
                      [
                        '',
                        '',
                        '',
                        'Total:',
                        'PKR ${data['financial_info']['total_debit']}'
                      ],
                      fontSize: 10,
                      isBold: true,
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                pw.Text('On behalf of ${data['company_info']['name']}',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 10),

                pw.Divider(thickness: 1),
                // Bank details section as before...
                pw.Text('Bank Account Details with Account Title',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(4),
                  },
                  children: [
                    _buildTableRow(
                      ['Acc Title', 'Bank Name', 'Account No', 'Bank Address'],
                      isHeader: true,
                      fontSize: 10,
                    ),
                    ...['Askari Bank', 'Meezan Bank', 'Alfalah Bank', 'HBL']
                        .map((bank) {
                      return _buildTableRow(
                        [
                          'JO TRAVELS',
                          bank,
                          bank == 'Askari Bank'
                              ? '000123300000'
                              : bank == 'Meezan Bank'
                                  ? '000112000108'
                                  : bank == 'Alfalah Bank'
                                      ? '000007676001'
                                      : '010101010',
                          bank == 'Askari Bank'
                              ? 'Satyana Road Branch, Faisalabad'
                              : bank == 'Meezan Bank'
                                  ? 'Susan Road Branch, Faisalabad'
                                  : bank == 'Alfalah Bank'
                                      ? 'PC Branch, Faisalabad'
                                      : 'CANL ROAD BRANCH',
                        ],
                        fontSize: 10,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'Invoice_${data['voucher_info']['voucher_id']}',
      );
    } catch (e) {
      // Make sure to close loading dialog if there's an error
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (context.mounted) {
        CustomSnackBar(
          message: "Failed to generate invoice: ${e.toString()}",
          backgroundColor: TColor.third,
        );
      }
    }
  }

// / Helper to build table rows
  pw.TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, double fontSize = 12, bool isBold = false}) {
    return pw.TableRow(
      children: cells.map((cell) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            cell,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: isHeader || isBold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
