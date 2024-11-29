// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../accounts/accounts/account_controller.dart';
// import 'entry_controller.dart';
//
// class ReusableEntryCard extends StatelessWidget {
//   final Color primaryColor;
//   final Color textFieldColor;
//   final Color textColor;
//   final Color placeholderColor;
//   final bool showImageUpload;
//   final Function(double, double)? onTotalChanged;
//
//   ReusableEntryCard({
//     Key? key,
//     required this.primaryColor,
//     required this.textFieldColor,
//     required this.textColor,
//     required this.placeholderColor,
//     this.showImageUpload = false,
//     this.onTotalChanged,
//   }) : super(key: key);
//
//   final accountController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final debitController = TextEditingController();
//   final creditController = TextEditingController();
//
//   void _clearControllers() {
//     accountController.clear();
//     descriptionController.clear();
//     debitController.clear();
//     creditController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final voucherController = Get.find<VoucherController>();
//     final accountsController = Get.find<AccountsController>();
//
//     return Column(
//       children: [
//         // Add Entry Card
//         Card(
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Account Dropdown
//                 Autocomplete<String>(
//                   optionsBuilder: (TextEditingValue textEditingValue) {
//                     if (textEditingValue.text.isEmpty) {
//                       return accountsController.accounts
//                           .map((account) => account.name)
//                           .toList();
//                     }
//                     return accountsController.accounts
//                         .where((account) => account.name
//                         .toLowerCase()
//                         .contains(textEditingValue.text.toLowerCase()))
//                         .map((account) => account.name)
//                         .toList();
//                   },
//                   onSelected: (String selection) {
//                     accountController.text = selection;
//                   },
//                   fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
//                     accountController.text = controller.text;
//                     return TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       decoration: InputDecoration(
//                         labelText: 'Account',
//                         filled: true,
//                         fillColor: textFieldColor,
//                         labelStyle: TextStyle(color: placeholderColor),
//                       ),
//                       style: TextStyle(color: textColor),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 8),
//
//                 // Description TextField
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(
//                     labelText: 'Description',
//                     filled: true,
//                     fillColor: textFieldColor,
//                     labelStyle: TextStyle(color: placeholderColor),
//                   ),
//                   style: TextStyle(color: textColor),
//                 ),
//                 const SizedBox(height: 8),
//
//                 // Debit and Credit Fields Row
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: debitController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Debit',
//                           filled: true,
//                           fillColor: textFieldColor,
//                           labelStyle: TextStyle(color: placeholderColor),
//                         ),
//                         style: TextStyle(color: textColor),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextField(
//                         controller: creditController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Credit',
//                           filled: true,
//                           fillColor: textFieldColor,
//                           labelStyle: TextStyle(color: placeholderColor),
//                         ),
//                         style: TextStyle(color: textColor),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Add Entry Button
//                 ElevatedButton(
//                   onPressed: () {
//                     final entry = EntryModel(
//                       account: accountController.text,
//                       description: descriptionController.text,
//                       debit: double.tryParse(debitController.text) ?? 0.0,
//                       credit: double.tryParse(creditController.text) ?? 0.0,
//                     );
//                     voucherController.addEntry(entry);
//                     _clearControllers();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                   ),
//                   child: const Text('Add Entry'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // List of Entries
//         Obx(() => Column(
//           children: [
//             ...voucherController.entries.asMap().entries.map((entry) {
//               final index = entry.key;
//               final item = entry.value;
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 child: ListTile(
//                   title: Text(item.account),
//                   subtitle: Text(item.description),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('D: ${item.debit}'),
//                       const SizedBox(width: 8),
//                       Text('C: ${item.credit}'),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => voucherController.removeEntry(index),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//             // Totals
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text('Total Debit: ${voucherController.totalDebit.value}'),
//                   const SizedBox(width: 16),
//                   Text('Total Credit: ${voucherController.totalCredit.value}'),
//                 ],
//               ),
//             ),
//           ],
//         )),
//       ],
//     );
//   }
// }
