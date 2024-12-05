
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../common/color_extension.dart';

class PDFPreviewScreen extends StatelessWidget {
  final File pdfFile;

  const PDFPreviewScreen({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: TColor.white),
        title: Text(
          'PDF Preview',
          style: TextStyle(
            color: TColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PdfPreview(
        build: (format) => pdfFile.readAsBytesSync(),
        allowSharing: true,
        allowPrinting: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        padding: const EdgeInsets.all(8),
       scrollViewDecoration: BoxDecoration(
         color: TColor.textfield,
       ),
        actionBarTheme: PdfActionBarTheme(
          backgroundColor: TColor.primary
        ),
      ),
    );
  }
}