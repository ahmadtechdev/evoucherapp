import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../entry_card.dart';


class BankEntryVoucher extends StatefulWidget {
  const BankEntryVoucher({super.key});

  @override
  State<BankEntryVoucher> createState() => _BankEntryVoucherState();
}

class _BankEntryVoucherState extends State<BankEntryVoucher> {
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
          title: const Text('Bank Voucher'),
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateSelector(
                  fontSize: 16,
                  initialDate: selectedDate,
                  label: "DATE:",
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // In your build method:
                ReusableEntryCard(
                  // Your list of accounts
                  showImageUpload: true, // or false if you don't want image upload
                  primaryColor: TColor.primary,
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


// // bank_entry_voucher.dart
// import 'package:evoucher/common_widget/snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../common/color_extension.dart';
// import '../../../common_widget/date_selecter.dart';
// import '../entry_card.dart';
// import 'bank_voucher_provider.dart';
//
// class BankEntryVoucher extends ConsumerStatefulWidget {
//   const BankEntryVoucher({super.key});
//
//   @override
//   ConsumerState<BankEntryVoucher> createState() => _BankEntryVoucherState();
// }
//
// class _BankEntryVoucherState extends ConsumerState<BankEntryVoucher> {
//   bool _isSaving = false;
//   late final ReusableEntryCard _entryCard;
//   DateTime selectedDate = DateTime.now();
//   double totalDebit = 0.0;
//   double totalCredit = 0.0;
//   final FocusNode _mainFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _entryCard = ReusableEntryCard(
//       showImageUpload: true,
//       showChequeField: true,
//       primaryColor: TColor.primary,
//       textFieldColor: TColor.textfield,
//       textColor: TColor.white,
//       placeholderColor: TColor.placeholder,
//       onTotalChanged: (debit, credit) {
//         setState(() {
//           totalDebit = debit;
//           totalCredit = credit;
//         });
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _mainFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _saveVoucher() async {
//     if (_isSaving) return;
//
//     // Validate totals match
//     if ((totalDebit - totalCredit).abs() > 0.001) {
//       // _showErrorSnackbar('Debit and Credit must be equal');
//       CustomSnackBar(
//         message: 'Debit and Credit must be equal',
//         backgroundColor: TColor.third,
//       ).show(context);
//       return;
//     }
//
//     // Get entries from provider
//     final entries = ref.read(entriesProvider);
//
//     // Validate entries
//     if (entries.isEmpty) {
//       // _showErrorSnackbar('Please add at least one entry');
//       CustomSnackBar(
//         message: 'Please add at least one entry',
//         backgroundColor: TColor.third,
//       ).show(context);
//       return;
//     }
//
//     // Transform entries to API format
//     final formattedEntries = entries.map((entry) {
//       final Map<String, dynamic> entryMap = {
//         'account_id': entry.account,
//         'description': entry.descriptionController?.text ?? '',
//         'debit': entry.debit,
//         'credit': entry.credit,
//       };
//
//       // Add optional fields
//       if (entry.chequeController?.text.isNotEmpty ?? false) {
//         entryMap['cheque_no'] = entry.chequeController!.text;
//       }
//
//       // Handle image if present
//       if (entry.imageFile != null) {
//         // You would implement image upload logic here
//         // entryMap['image'] = await uploadImage(entry.imageFile!);
//       }
//
//       return entryMap;
//     }).toList();
//
//     setState(() => _isSaving = true);
//
//     try {
//       // Submit using provider
//       await ref.read(bankVoucherProvider.notifier).submitVoucher(
//             date: selectedDate.toString(),
//             entries: formattedEntries,
//           );
//
//       // _showSuccessSnackbar('Bank Voucher saved successfully');
//       CustomSnackBar(
//         message: "Bank Voucher saved successfully",
//         backgroundColor: TColor.secondary,
//       ).show(context);
//       if (mounted) {
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       // _showErrorSnackbar('Failed to save voucher: $e');
//       CustomSnackBar(
//         message: "Failed to save voucher: $e",
//         backgroundColor: TColor.third,
//       ).show(context);
//     } finally {
//       if (mounted) {
//         setState(() => _isSaving = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Watch bank voucher state for loading
//     final bankVoucherState = ref.watch(bankVoucherProvider);
//     final isLoading = bankVoucherState is AsyncLoading;
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).requestFocus(_mainFocusNode),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bank Voucher'),
//           backgroundColor: TColor.primary,
//           foregroundColor: TColor.white,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DateSelector(
//                   fontSize: 16,
//                   initialDate: selectedDate,
//                   label: "DATE:",
//                   onDateChanged: (newDate) {
//                     setState(() {
//                       selectedDate = newDate;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 _entryCard,
//                 const SizedBox(height: 24),
//                 Center(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width / 1.5,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : _saveVoucher,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: TColor.secondary,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                       ),
//                       child: isLoading
//                           ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(TColor.white),
//                               ),
//                             )
//                           : Text(
//                               'Save',
//                               style: TextStyle(
//                                 color: TColor.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
