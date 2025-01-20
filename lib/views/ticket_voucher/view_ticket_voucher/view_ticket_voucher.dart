import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../common/color_extension.dart';
import '../../../common_widget/dart_selector2.dart';
import 'ticket_invoices_view/refund/refund_ticket.dart';
import 'ticket_invoices_view/view/view_single_ticket_voucher.dart';
import 'view_ticket_voucher_controller.dart';

class ViewTicketVoucher extends StatelessWidget {
  final TicketVoucherController controller = Get.put(TicketVoucherController());

  ViewTicketVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Ticket Vouchers'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DateSelector2(
                        label: 'From Date',
                        fontSize: 14,
                        initialDate: controller.fromDate.value,
                        onDateChanged: (DateTime value) {
                          controller.updateDateRange(
                              value, controller.toDate.value);
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DateSelector2(
                        label: 'To Date',
                        fontSize: 14,
                        initialDate: controller.toDate.value,
                        onDateChanged: (DateTime value) {
                          controller.updateDateRange(
                              controller.fromDate.value, value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
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
                        'There are no ticket vouchers in this date range',
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
}

Widget _buildVoucherCard(Map<String, dynamic> ticket, BuildContext context) {
  final details = ticket['details'] as Map<String, dynamic>;
  final ticketDetails = ticket['ticket_details'] as Map<String, dynamic>;
  final refundStatus = ticketDetails['refund_status'] as Map<String, dynamic>;

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
            color: ticket['needs_attention'] == true
                ? Colors.red.withOpacity(0.15)
                : TColor.primary.withOpacity(0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.confirmation_number,
                  color: ticket['needs_attention'] == true
                      ? Colors.red
                      : TColor.primary),
              const SizedBox(width: 10),
              Text(
                'TV ID: ${ticket['voucher_id']}',
                style: TextStyle(
                  color: ticket['needs_attention'] == true
                      ? Colors.red
                      : TColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.visibility,
                    color: ticket['needs_attention'] == true
                        ? Colors.red
                        : TColor.primary),
                onPressed: () {
                  Get.to(() => const TicketViewSingleVoucher());
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
              _buildInfoRow(
                  Icons.person, 'Customer', details['customer_account'] ?? ''),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.flight, 'PNR', ticketDetails['pnr'] ?? ''),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.description, 'Description',
                  details['description'] ?? ''),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.business, 'Supplier Account',
                  details['supplier_account'] ?? ''),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                        Icons.person_add, 'Added by', ticket['added_by'] ?? ''),
                  ),
                  Text(
                    'PKR ${details['selling_amount']}',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (refundStatus['is_refunded'] == true ||
                  refundStatus['is_partially_refunded'] == true)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Refund Status: ${refundStatus['status_text']}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Refund',
                      Icons.currency_exchange,
                      refundStatus['is_refunded'] == true
                          ? Colors.grey
                          : TColor.third,
                      onPressed: refundStatus['is_refunded'] == true
                          ? null
                          : () =>
                              Get.to(() => const TicketRefundTicketScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Invoice',
                      Icons.receipt_long,
                      TColor.primary,
                      onPressed: () => generateAndPreviewInvoice(context),
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

Widget _buildActionButton(String label, IconData icon, Color backgroundColor,
    {VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor.withOpacity(0.7),
      foregroundColor: TColor.white,
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

Future<void> generateAndPreviewInvoice(BuildContext context) async {
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
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
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
                      // Address
                      pw.Text(
                          '2nd Floor JOURNEY ONLINE Plaza, Al-hamra town, east canal road, Faisalabad',
                          style: const pw.TextStyle(fontSize: 10)),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'CELL : ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: '03337323379',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: ' - PHONE : ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: '03037666866',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: ' - EMAIL : ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: 'ameeramillattts@hotmail.com',
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
                    pw.RichText(
                        text: pw.TextSpan(children: [
                      pw.TextSpan(
                        text: 'NTN: ',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10),
                      ),
                      pw.TextSpan(
                        text: 'HUN6678',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10),
                      ),
                    ])),
                    pw.RichText(
                        text: pw.TextSpan(children: [
                      pw.TextSpan(
                        text: 'Company ID: ',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10),
                      ),
                      pw.TextSpan(
                        text: 'HGDFR58',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10),
                      ),
                    ])),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      width: 100,
                      padding: const pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 2),
                      ),
                      child: pw.Column(children: [
                        pw.Text('Invoices'),
                        pw.SizedBox(height: 4),
                        pw.Text('(PKR) = 11.00'),
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
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(1),
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                _buildTableRow(
                  ['Invoice #', 'Account Name', 'Invoice Date', 'PKR'],
                  isHeader: true,
                  fontSize: 10,
                ),
                _buildTableRow(
                  ['950', 'Ticket Income', 'Tue, 24 Dec 2024', ''],
                  fontSize: 10,
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Passenger details table
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                _buildTableRow(
                  [
                    'Passenger Name',
                    'Airline',
                    'Ticket #',
                    'Sector',
                    'Amount (PKR)'
                  ],
                  isHeader: true,
                  fontSize: 10,
                ),
                _buildTableRow(
                  ['hsl', 'PIA', '', 'GJSl', '11.00'],
                  fontSize: 10,
                ),
                _buildTableRow(
                  ['Total:', '', '', '', 'PKR 11.00'],
                  fontSize: 10,
                  isBold: true,
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            // In words
            pw.Text('IN WORDS: Eleven Rupees Only',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.SizedBox(height: 10),
            pw.Text('On behalf of AGENT1',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.SizedBox(height: 10),

            pw.Divider(thickness: 1),
            // Bank details section
            pw.Text('Bank Account Details with Account Title',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
            pw.SizedBox(height: 10),
          ],
        ),
      ],
    ),
  );

  // Show print preview
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
    name: 'Invoice_950',
  );
}

// Helper to build table rows
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
            fontWeight:
                isHeader || isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );
    }).toList(),
  );
}
