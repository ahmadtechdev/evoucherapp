import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../widgets/entry_card.dart';
import 'package:intl/intl.dart';

import '../controller/entry_controller.dart';

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
  late final VoucherController voucherController;
  List<Map<String, dynamic>> entries = [];
  Map<String, dynamic> masterData = {};

  @override
  void initState() {
    super.initState();

    try {
      // The data is now already in the correct format
      masterData = widget.voucherData['master'] as Map<String, dynamic>? ?? {};

      final detailsData = widget.voucherData['details'] as List? ?? [];

      try {

        selectedDate =
            DateFormat('EEE, dd MMM yyyy').parse(masterData['voucher_data']);
      } catch (e) {
        // print('Error parsing date: $e');
        selectedDate = DateTime.now();
      }



      // Map the details data to entries format
      entries = detailsData.map((entry) {
        return {
          'account': entry['account_name'] ?? "",
          'account_id': entry['account_id'] ?? "",
          'description': entry['description'] ?? '',
          'debit': double.tryParse(entry['debit']?.toString() ?? '0.0') ?? 0.0,
          'credit':
              double.tryParse(entry['credit']?.toString() ?? '0.0') ?? 0.0,
        };
      }).toList();

      if (entries.isEmpty) {
        entries = [
          {
            'account': "",
            'account_id': "",
            'description': '',
            'debit': 0.0,
            'credit': 0.0,
          }
        ];
      }
    } catch (e) {
      // print('Error initializing data: $e');
      entries = [
        {
          'account': "",
          'account_id': "",
          'description': '',
          'debit': 0.0,
          'credit': 0.0,
        }
      ];
    }

    voucherController = Get.find<VoucherController>();
    voucherController.clearEntries();
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  // void _showDeleteConfirmation() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Delete Voucher',
  //           style: TextStyle(color: TColor.primaryText),
  //         ),
  //         content: Text(
  //           'Do you really want to delete this voucher?',
  //           style: TextStyle(color: TColor.secondaryText),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'No',
  //               style: TextStyle(color: TColor.primary),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               Get.back();
  //             },
  //             child: Text(
  //               'Yes',
  //               style: TextStyle(color: TColor.third),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // Widget _buildHeaderButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       IconButton(
  //         icon: Icon(Icons.arrow_back, color: TColor.primaryText),
  //         onPressed: () => Get.back(),
  //       ),
  //       // Row(
  //       //   children: [
  //       //     if (!isEditMode) ...[
  //       //       IconButton(
  //       //         icon: Icon(Icons.edit, color: TColor.primary),
  //       //         onPressed: () {
  //       //           setState(() {
  //       //             isEditMode = true;
  //       //           });
  //       //         },
  //       //       ),
  //       //       IconButton(
  //       //         icon: Icon(Icons.delete, color: TColor.third),
  //       //         onPressed: _showDeleteConfirmation,
  //       //       ),
  //       //     ],
  //       //   ],
  //       // ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_mainFocusNode);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
          // title: Text('Journal Voucher #${masterData['voucher_id'] ?? ''}'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildHeaderButtons(),
                  Text(
                    'Journal Voucher #${masterData['voucher_id'] ?? ''}',
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    textFieldColor: TColor.textField,
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
                        width: MediaQuery.of(context).size.width / 1.5,
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
