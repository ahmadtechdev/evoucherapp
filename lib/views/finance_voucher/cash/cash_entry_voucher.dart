import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';
import '../entry_controller.dart';

class CashEntryVoucher extends StatefulWidget {
  const CashEntryVoucher({super.key});

  @override
  State<CashEntryVoucher> createState() => _CashEntryVoucherState();
}

class _CashEntryVoucherState extends State<CashEntryVoucher> {
  DateTime selectedDate = DateTime.now();

  double totalDebit = 0.0;
  double totalCredit = 0.0;
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
        // Dismiss keyboard when tapping outside any input
        FocusScope.of(context).requestFocus(_mainFocusNode);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cash Voucher'),
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, // 6% of screen width
              vertical: screenHeight * 0.01,  // 1% of screen height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateSelector(
                  fontSize: screenHeight * 0.018, // Scaled font size
                  vpad: screenHeight * 0.01,    // Scaled vertical padding
                  initialDate: selectedDate,
                  label: "DATE:",
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.01), // 1% of screen height
                ReusableEntryCard(
                  showImageUpload: true, // or false if you don't want image upload
                  primaryColor: TColor.primary,
                  textFieldColor: TColor.textfield,
                  textColor: TColor.white,
                  placeholderColor: TColor.placeholder,

                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6, // 60% of screen width
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015), // Scaled vertical padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: screenHeight * 0.02, // Scaled font size
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
