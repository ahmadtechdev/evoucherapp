import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';


class JournalEntryVoucher extends StatefulWidget {
  const JournalEntryVoucher({super.key});

  @override
  State<JournalEntryVoucher> createState() => _JournalEntryVoucherState();
}

class _JournalEntryVoucherState extends State<JournalEntryVoucher> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside any input
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateSelector(
                  fontSize: 14,
                  vpad: 8,
                  initialDate: selectedDate,
                  label: "DATE:",
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 8),
                // In your build method:
                ReusableEntryCard(
                  showImageUpload: false, // or false if you don't want image upload
                  primaryColor: TColor.primary,
                  textFieldColor: TColor.textfield,
                  textColor: TColor.white,
                  placeholderColor: TColor.placeholder,
                  onTotalChanged: (totalDebit, totalCredit) {
                    // Optional: Handle total changes in parent widget
                    print('Total Debit: $totalDebit, Total Credit: $totalCredit');
                  },
                ),
                const SizedBox(height: 12),
               Center(
                  child: SizedBox(
                    width: screenWidth/1.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement save functionality
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
    );
  }
}