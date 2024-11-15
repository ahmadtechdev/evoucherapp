import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../entry_card.dart';

class ViewUnPostedVouchers extends StatefulWidget {
  const ViewUnPostedVouchers({super.key});

  @override
  State<ViewUnPostedVouchers> createState() => _ViewUnPostedVouchersState();
}

class _ViewUnPostedVouchersState extends State<ViewUnPostedVouchers> {

  List<String> accounts = [
    'Cash Account',
    'Bank Account',
    'Sales Account',
    'Purchase Account',
    'Accounts Receivable',
    'Accounts Payable',
    'Capital Account',
    'Drawing Account',
    'Expense Account',
    'Revenue Account'
  ];
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Voucher'),
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // In your build method:
            ReusableEntryCard(
              accounts: accounts, // Your list of accounts
              showImageUpload: false, // or false if you don't want image upload
              primaryColor: TColor.primary,
              isViewMode: true,
              showAddRowButton: false,
              textFieldColor: TColor.textfield,
              textColor: TColor.white,
              placeholderColor: TColor.placeholder,
              onTotalChanged: (totalDebit, totalCredit) {
                // Optional: Handle total changes in parent widget
                print('Total Debit: $totalDebit, Total Credit: $totalCredit');
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: screenWidth/1.5,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.fourth,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_rounded, color: TColor.primaryText,),
                      Text(
                        'POST JV#862',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
