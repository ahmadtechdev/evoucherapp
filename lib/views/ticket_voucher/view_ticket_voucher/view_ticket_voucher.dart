import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:evoucher/views/ticket_voucher/view_ticket_voucher/view_ticket_voucher_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

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
                        initialDate: DateTime.now(),
                        onDateChanged: (DateTime value) {},
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DateSelector2(
                        label: 'To Date',
                        fontSize: 14,
                        initialDate: DateTime.now(),
                        onDateChanged: (DateTime value) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.ticketVouchers.length,
                  itemBuilder: (context, index) {
                    var ticket = controller.ticketVouchers[index];
                    return _buildVoucherCard(ticket, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, String> ticket, BuildContext context) {
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
              color: TColor.primary.withOpacity(0.15),
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
                  'TV ID: ${ticket['tv_id']}',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.visibility, color: TColor.primary),
                  onPressed: () {
                    // Implement view action
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
                    Icons.person, 'Customer', ticket['customer'] ?? ''),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.flight, 'PNR', ticket['pnr'] ?? ''),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.description, 'Description',
                    ticket['description'] ?? ''),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.business, 'Supplier Account',
                    ticket['supplier'] ?? ''),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(Icons.person_add, 'Added by',
                          ticket['added_by'] ?? ''),
                    ),
                    Text(
                      'PKR ${ticket['price']}',
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                          'Invoice 1', Icons.receipt, context, ticket),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                          'Invoice 2', Icons.receipt_long, context, ticket),
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

  Widget _buildActionButton(String label, IconData icon, BuildContext context,
      Map<String, String> ticket) {
    return ElevatedButton(
      onPressed: () {
        generateAndPreviewInvoice(context);
      },
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
  Future<void> generateAndPreviewInvoice(BuildContext context) async {
    // Create PDF document
    final doc = pw.Document();

    // Load logo from assets
    final logoImage = await rootBundle.load('assets/img/logo1.png');
    final logoImageData = logoImage.buffer.asUint8List();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
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
                      pw.Text('2nd Floor JOURNEY ONLINE Plaza, Al-hamra town, east canal road, Faisalabad',
                          style: const pw.TextStyle(fontSize: 10)),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'CELL : ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: '03337323379',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: ' - PHONE : ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: '03037666866',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: ' - EMAIL : ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: 'ameeramillattts@hotmail.com',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                            ),
                          ],
                        ),
                      ),

                    ]
                  ),


                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'NTN: ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: 'HUN6678',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                            ),
                          ]
                        )
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Company ID: ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            ),
                            pw.TextSpan(
                              text: 'HGDFR58',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                            ),
                          ]
                        )
                      ),

                      pw.SizedBox(
                        height: 8
                      ),
                      pw.Container(
                        width: 100,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 2),
                        ),
                        child: pw.Column(
                            children: [

                              pw.Text('Invoices'),
                              pw.SizedBox(
                                  height: 4
                              ),
                              pw.Text('(PKR) = 11.00'),
                            ]
                        ),)
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
                    ['Passenger Name', 'Airline', 'Ticket #', 'Sector', 'Amount (PKR)'],
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
              pw.Text('IN WORDS: Eleven Rupees Only', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Text('On behalf of AGENT1', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 10),

              pw.Divider(thickness: 1),
              // Bank details section
              pw.Text('Bank Account Details with Account Title', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
                  ...['Askari Bank', 'Meezan Bank', 'Alfalah Bank', 'HBL'].map((bank) {
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
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 10),

            ],
          );
        },
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_950',
    );
  }

// Helper to build table rows
  pw.TableRow _buildTableRow(List<String> cells, {bool isHeader = false, double fontSize = 12, bool isBold = false}) {
    return pw.TableRow(
      children: cells.map((cell) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            cell,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: isHeader || isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

}
