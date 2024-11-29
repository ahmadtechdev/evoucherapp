import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';
import '../entry_controller.dart';

class JournalEntryVoucher extends StatefulWidget {
  const JournalEntryVoucher({super.key});

  @override
  State<JournalEntryVoucher> createState() => _JournalEntryVoucherState();
}

class _JournalEntryVoucherState extends State<JournalEntryVoucher> {
  DateTime selectedDate = DateTime.now();
  final FocusNode _mainFocusNode = FocusNode();
  late final VoucherController voucherController;

  @override
  void initState() {
    super.initState();
    // Use Get.find instead of Get.put to ensure the controller is already registered
    voucherController = Get.find<VoucherController>();

    // Clear any existing entries when the page is first loaded
    voucherController.clearEntries();
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Get all entries from the controller
    final entries = voucherController.entries;

    // Validate entries
    if (entries.isEmpty) {
      Get.snackbar(
        'Error',
        'No entries to save',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check if debits and credits are equal
    double totalDebit = 0.0;
    double totalCredit = 0.0;

    for (var entry in entries) {
      totalDebit += entry.debit;
      totalCredit += entry.credit;
    }

    if (totalDebit != totalCredit) {
      Get.snackbar(
        'Error',
        'Total debit and credit must be equal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Print entries for debugging
    print('Date: $selectedDate');
    print('Entries:');
    for (var entry in entries) {
      print('Account: ${entry.account}');
      print('Description: ${entry.description}');
      print('Debit: ${entry.debit}');
      print('Credit: ${entry.credit}');
      print('-------------------');
    }
    print('Total Debit: $totalDebit');
    print('Total Credit: $totalCredit');

    // Show success message
    Get.snackbar(
      'Success',
      'Journal entry saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Clear entries after saving
    voucherController.clearEntries();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_mainFocusNode);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Journal Voucher'),
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateSelector(
                  fontSize: screenHeight * 0.018,
                  vpad: screenHeight * 0.01,
                  initialDate: selectedDate,
                  label: "DATE:",
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                ReusableEntryCard(
                  showImageUpload: false,
                  primaryColor: TColor.primary,
                  textFieldColor: TColor.textfield,
                  textColor: TColor.white,
                  placeholderColor: TColor.placeholder,
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: screenHeight * 0.02,
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
    );
  }
}