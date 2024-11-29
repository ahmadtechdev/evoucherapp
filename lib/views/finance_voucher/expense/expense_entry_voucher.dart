import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';

class ExpenseEntryVoucher extends StatefulWidget {
  const ExpenseEntryVoucher({super.key});

  @override
  State<ExpenseEntryVoucher> createState() => _ExpenseEntryVoucherState();
}

class _ExpenseEntryVoucherState extends State<ExpenseEntryVoucher> {
  DateTime selectedDate = DateTime.now();

  double totalDebit = 0.0;
  double totalCredit = 0.0;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void dispose() {
    _mainFocusNode.dispose();

    super.dispose();
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
          title: const Text('Expense Voucher'),
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
                  onTotalChanged: (totalDebit, totalCredit) {
                    // Optional: Handle total changes in parent widget
                    print('Total Debit: \$totalDebit, Total Credit: \$totalCredit');
                  },
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6, // 60% of screen width
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement save functionality
                      },
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
