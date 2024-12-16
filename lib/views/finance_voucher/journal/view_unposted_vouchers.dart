import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../widgets/entry_card.dart';

class ViewUnPostedVouchers extends StatefulWidget {
  const ViewUnPostedVouchers({super.key});

  @override
  State<ViewUnPostedVouchers> createState() => _ViewUnPostedVouchersState();
}

class _ViewUnPostedVouchersState extends State<ViewUnPostedVouchers> {

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // In your build method:
            ReusableEntryCard(

              showImageUpload: false, // or false if you don't want image upload
              primaryColor: TColor.primary,
              // isViewMode: true,
              // showAddRowButton: false,
              textFieldColor: TColor.textfield,
              textColor: TColor.white,
              placeholderColor: TColor.placeholder,
              onTotalChanged: (totalDebit, totalCredit) {
                // Optional: Handle total changes in parent widget
                print('Total Debit: $totalDebit, Total Credit: $totalCredit');
              },
            ),
            const SizedBox(height: 18),
            Center(
              child: SizedBox(
                width: screenWidth/1.5,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_rounded, color: TColor.white,),
                      Text(
                        'POST JV#862',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
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
