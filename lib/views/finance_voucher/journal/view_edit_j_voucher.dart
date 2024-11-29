import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';
import 'package:intl/intl.dart';

import '../entry_controller.dart';

class JournalVoucherDetail extends StatefulWidget {
  final Map<String, dynamic> voucherData;

  const JournalVoucherDetail({
    super.key,
    required this.voucherData,
  });

  @override
  State<JournalVoucherDetail> createState() => _JournalVoucherDetailState();
}

class _JournalVoucherDetailState extends State<JournalVoucherDetail> {
  bool isEditMode = false;
  DateTime selectedDate = DateTime.now();
  final FocusNode _mainFocusNode = FocusNode();
  double totalDebit = 0.0;
  double totalCredit = 0.0;
  late final VoucherController voucherController;
  List<Map<String, dynamic>> entries = [];


  @override
  void initState() {
    super.initState();
    try {
      // Parse date
      String dateString = widget.voucherData['date'] as String;
      selectedDate = DateFormat('EEE, dd MMM yyyy').parse(dateString);

      // Safely initialize entries
      if (widget.voucherData['entries'] != null &&
          widget.voucherData['entries'] is List &&
          (widget.voucherData['entries'] as List).isNotEmpty) {

        var entriesList = widget.voucherData['entries'] as List;
        entries = entriesList.map((entry) {
          return {
            'account': entry['account'] ?? "",
            'description': widget.voucherData['description'] ?? '',
            'debit': 0.0,
            'credit': _parseAmount(widget.voucherData['amount']),
          };
        }).toList();
      } else {
        // Fallback entry if no entries exist
        entries = [{
          'account': "",
          'description': widget.voucherData['description'] ?? '',
          'debit': 0.0,
          'credit': _parseAmount(widget.voucherData['amount']),
        }];
      }
    } catch (e) {
      print('Error initializing data: $e');
      // Fallback entry
      entries = [{
        'account': "",
        'description': '',
        'debit': 0.0,
        'credit': 0.0,
      }];
    }

    // Use Get.find instead of Get.put to ensure the controller is already registered
    voucherController = Get.find<VoucherController>();

    // Clear any existing entries when the page is first loaded
    voucherController.clearEntries();
  }

  double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is num) return amount.toDouble();
    if (amount is String) {
      try {
        return double.parse(amount.replaceAll('PKR ', '').replaceAll(',', ''));
      } catch (e) {
        print('Error parsing amount: $e');
        return 0.0;
      }
    }
    return 0.0;
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Voucher',
            style: TextStyle(color: TColor.primaryText),
          ),
          content: Text(
            'Do you really want to delete this voucher?',
            style: TextStyle(color: TColor.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'No',
                style: TextStyle(color: TColor.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Get.back();
              },
              child: Text(
                'Yes',
                style: TextStyle(color: TColor.third),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.primaryText),
          onPressed: () => Get.back(),
        ),

        Row(
          children: [
            if (!isEditMode) ...[
              IconButton(
                icon: Icon(Icons.edit, color: TColor.primary),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: TColor.third),
                onPressed: _showDeleteConfirmation,
              ),
            ],
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_mainFocusNode);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderButtons(),
                  Text(
                    'Journal Voucher #${widget.voucherData['id'] ?? ''}',
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     if (!isEditMode) ...[
                  //       IconButton(
                  //         icon: Icon(Icons.edit, color: TColor.primary),
                  //         onPressed: () {
                  //           setState(() {
                  //             isEditMode = true;
                  //           });
                  //         },
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.delete, color: TColor.third),
                  //         onPressed: _showDeleteConfirmation,
                  //       ),
                  //     ],
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  DateSelector(
                    fontSize: 16,
                    initialDate: selectedDate,
                    label: "DATE:",
                    onDateChanged: (newDate) {
                      if (isEditMode) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ReusableEntryCard(

                    showImageUpload: false,
                    primaryColor: TColor.primary,
                    textFieldColor: TColor.textfield,
                    textColor: TColor.white,
                    placeholderColor: TColor.placeholder,
                    isViewMode: !isEditMode,

                    showPrintButton: !isEditMode,
                    initialData: entries,
                  ),
                  const SizedBox(height: 24),
                  if (isEditMode)
                    Center(
                      child: SizedBox(
                        width: screenWidth/1.5,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditMode = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}