import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceGenerator {


  Future<void> generateAndPreviewNewHotelInvoice(BuildContext context) async {
    // Create PDF document
    final doc = pw.Document();

    // Load logo from assets
    final logoImage = await rootBundle.load('assets/img/logo1.png');
    final logoImageData = logoImage.buffer.asUint8List();

    // Get current date and time
    final now = DateTime.now();
    final formattedDateTime = '${now.toLocal()}';

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
              // Date and time row at the top
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  'Date & Time: $formattedDateTime',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
              ),
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
                        width: 120,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 2),
                        ),
                        child: pw.Column(
                            children: [

                              pw.Text('Invoices: 852'),
                              pw.SizedBox(
                                  height: 4
                              ),
                              pw.Text('(PKR) = 14,000.00'),
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
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildTableRow(
                    ['Account Name:', 'Hotel Invoice Date #', 'Option Date', 'Confirmation'],
                    isHeader: true,
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['Adam', 'Thu, 31 Oct 2024', '30, Nov -0001', ''],
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
                  5: const pw.FlexColumnWidth(2),
                  6: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildTableRow(
                    ['Pax Name', 'Hotel', 'Room Type #', 'Meal', 'Destination','CheckIn - CheckOut','Amount (PKR)'],
                    isHeader: true,
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['Hassan', 'ABC TEST GTEl', 'Double Room', 'None', 'Mecca- Saudia', 'Thu, 31 OCt, 2024 \n Sat, 02 Nov, 2024', '14,000.00'],
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['', '', '','','', 'Total:', 'PKR 14,000.00'],
                    fontSize: 10,
                    isBold: true,
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              // In words
              pw.Text('IN WORDS: Fourteen Thousands PkR Only', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
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
                  }),
                ],
              ),
              pw.SizedBox(height: 10),

            ],
          )
        ],
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_950',
    );
  }

  Future<void> generateAndPreviewDefiniteHotelInvoice(BuildContext context) async {
    // Create PDF document
    final doc = pw.Document();

    // Load logo from assets
    final logoImage = await rootBundle.load('assets/img/logo1.png');
    final logoImageData = logoImage.buffer.asUint8List();

    // Get current date and time
    final now = DateTime.now();
    final formattedDateTime = '${now.toLocal()}';

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
              // Date and time row at the top
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  'Date & Time: $formattedDateTime',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
              ),
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

                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 1),

              pw.SizedBox(height: 20),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: 'Account Name: | Adam',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                            ),
                            pw.TextSpan(
                              text: ' | 1234567890 | test@tests.com',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12),
                            ),
                          ]
                      )
                  ),

                  pw.Text(
                    'Definite Invoice',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                  ),
                ]
              ),

              pw.SizedBox(height: 10),

              // Invoice details table
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),

                },
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildTableRow(
                    ['Hotel Invoice Date #', 'Confirmation'],
                    isHeader: true,
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['Adam', 'Thu, 31 Oct 2024',],
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
                  5: const pw.FlexColumnWidth(2),
                  6: const pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildTableRow(
                    ['Pax Name', 'Hotel', 'Room Type #', 'Meal', 'Destination','CheckIn - CheckOut','Amount (PKR)'],
                    isHeader: true,
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['Hassan', 'ABC TEST GTEl', 'Double Room', 'None', 'Mecca- Saudia', 'Thu, 31 OCt, 2024 \n Sat, 02 Nov, 2024', '14,000.00'],
                    fontSize: 10,
                  ),
                  _buildTableRow(
                    ['', '', '','','', 'Total:', 'PKR 14,000.00'],
                    fontSize: 10,
                    isBold: true,
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              // In words
              pw.Text('IN WORDS: Fourteen Thousands PkR Only', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
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
                  }),
                ],
              ),
              pw.SizedBox(height: 10),

            ],
          )
        ],
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_950',
    );
  }

  Future<void> generateAndPreviewHotelVoucher(BuildContext context) async {
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
              // Header with logo and title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(pw.MemoryImage(logoImageData), width: 120),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Hotel Booking Voucher',
                          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        '2nd Floor JOURNEY ONLINE Plaza, Al hamra\ntown, east canal road, Faisalabad',
                        style: const pw.TextStyle(fontSize: 10),
                        textAlign: pw.TextAlign.right,
                      ),
                      pw.Text('Cell: 03337323379', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text('Phone: 03037666866', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Voucher and confirmation numbers
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Hotel Voucher: 852',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Confirmation No:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),

              pw.SizedBox(height: 20),

              // Hotel details
              pw.Text('HOTEL NAME',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('ABC TEST GTEL'),
              pw.Text('CITY / COUNTRY',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('MECCA-SAUDIA'),

              pw.SizedBox(height: 20),

              // Guest and room details in two columns
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('LEAD GUEST',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('HASSAN'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ROOM(S) / NIGHT(S)',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('1 / 2'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('CHECK-IN',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Thu, 31 Oct 2024'),
                      pw.SizedBox(height: 10),
                      pw.Text('CHECK-OUT',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Sat, 02 Nov 2024'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Room details table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                      // decoration: const pw.BoxDecoration(
                      //   color: PdfColor.fromInt(0xFF0C6B8A),
                      // ),

                    children: [
                      _buildHeaderCell('ROOMS/BEDS'),
                      _buildHeaderCell('Room Type'),
                      _buildHeaderCell('Meal'),
                      _buildHeaderCell('Guest Name'),
                      _buildHeaderCell('Adult(s)'),
                      _buildHeaderCell('Children'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildCell('1'),
                      _buildCell('DOUBLE ROOM'),
                      _buildCell('NONE'),
                      _buildCell('HASSAN'),
                      _buildCell('2'),
                      _buildCell(''),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Check-in/Check-out policies
              pw.Text('Check-in/Check-out Timings & Policies',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Bullet(text: 'The usual check-in time is 2:00/4:00 PM hours however this might vary from hotel to hotel and with different destinations.'),
              pw.Bullet(text: 'Rooms may not be available for early check-in, unless especially required in advance. However, luggage may be deposited at the hotel reception and collected once the room is allotted.'),
              pw.Bullet(text: 'Note that reservation may be canceled automatically after 18:00 hours if hotel is not informed about the approximate time of late arrivals.'),
              pw.Bullet(text: 'The usual checkout time is at 12:00 hours however this might vary from hotel to hotel and with different destinations. Any late checkout may involve additional charges. Please check with the hotel reception in advance.'),
              pw.Bullet(text: 'For any specific queries related to a particular hotel, kindly reach out to local support team for further assistance'),

              pw.SizedBox(height: 20),

              // Booking notes
              pw.Text('Booking Notes : Check your Reservation details carefully and inform us immediately,if you need any further clarification, please do not hesitate to contact us.',
                  style: const pw.TextStyle(fontSize: 10)),
            ],
          );
        },
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Hotel_Voucher_852',
    );
  }

  pw.Widget _buildHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text),
    );
  }


  Future<void> generateAndPreviewForeignInvoice(BuildContext context) async {
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
              // Logo centered
              pw.Center(
                child: pw.Image(pw.MemoryImage(logoImageData), width: 150),
              ),

              pw.SizedBox(height: 20),

              // Header information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Client Name: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: 'Adam'),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Subject: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: 'Definite Invoice'),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Confirmation#: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: 'N/A'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'HV#: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: '852'),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Date: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: 'Thu, 31 Oct 2024'),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Phone No: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(text: '03337323379'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Greeting text
              pw.Text('Greetings from UMER TRAVEL',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('First of all we would like to thank you for your support and cooperation extended towards UMER TRAVEL and we hope that this year bring success and truthful business relationship for both our esteemed company.'),
              pw.Text('We are please to confirm the following reservation on a UMER TRAVEL'),

              pw.SizedBox(height: 20),

              // Guest information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(text: 'Guest Name: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        const pw.TextSpan(text: 'HASSAN'),
                      ],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(text: 'Option Date: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        const pw.TextSpan(text: '30, Nov -0001'),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Reservation details table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1),
                  6: const pw.FlexColumnWidth(1),
                  7: const pw.FlexColumnWidth(1),
                },
                children: [
                  _buildTableHeaderRow([
                    'Hotel',
                    'Room',
                    'Meal',
                    'Checkin',
                    'Checkout',
                    'Rooms / Nights',
                    'Rate',
                    'Total(PKR)',
                  ]),
                  _buildTableDataRow([
                    'ABC TEST GTEL',
                    'DOUBLE ROOM',
                    'Room Only',
                    'Thu, 31 Oct 2024',
                    'Sat, 02 Nov 2024',
                    '1/2',
                    '100.00',
                    '200',
                  ]),
                ],
              ),

              // Total row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('PKR 14,000.00'),
                ],
              ),

              pw.SizedBox(height: 20),

              // Terms and Conditions
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('TERMS AND CONDITIONS',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),

              pw.SizedBox(height: 10),

              pw.Bullet(text: 'Above rates are net and non commission-able quoted in PKR.'),
              pw.Bullet(text: 'Once you Re-Confirm this booking it will be:'),
              pw.Bullet(text: 'Non Cancellation'),
              pw.Bullet(text: 'Non Refundable'),
              pw.Bullet(text: 'Non Amendable'),
              pw.Bullet(text: 'Check in after 16:00 hour and check out at 12:00 hour.'),
              pw.Bullet(text: 'Triple or Quad occupancy will be through extra bed # standard room is not available.'),

              pw.SizedBox(height: 20),

              // Bank Account Details
              pw.Text('Bank Account Details with Account Title AGENT1',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  _buildTableHeaderRow(['Bank name', 'Account No.', 'Bank Address']),
                  _buildTableDataRow(['Askari Bank', '000123300000', 'Satyana Road Branch, Faisalabad']),
                  _buildTableDataRow(['Meezan Bank', '000112000108', 'Susan Road Branch, Faisalabad']),
                  _buildTableDataRow(['Alfalah Bank', '000007676001', 'PC Branch, Faisalabad']),
                  _buildTableDataRow(['HBL', '010101010', 'CANL ROAD BRANCH']),
                ],
              ),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(

                padding: const pw.EdgeInsets.all(5),
                child: pw.Center(
                  child: pw.Text(
                    'Developed by Journeyonline.pk | CTC # 0310 0007901',
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Foreign_Invoice_852',
    );
  }

// Helper function to create table header rows
  pw.TableRow _buildTableHeaderRow(List<String> cells) {
    return pw.TableRow(

      children: cells.map((cell) => pw.Container(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          cell,
          style: pw.TextStyle(

            fontWeight: pw.FontWeight.bold,
          ),
        ),
      )).toList(),
    );
  }

// Helper function to create table data rows
  pw.TableRow _buildTableDataRow(List<String> cells) {
    return pw.TableRow(
      children: cells.map((cell) => pw.Container(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(cell),
      )).toList(),
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
