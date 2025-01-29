

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/color_extension.dart';
import '../../../../common_widget/date_selecter.dart';
import '../../../../common_widget/snackbar.dart';
import '../../../../service/api_service.dart';
import '../widgets/entry_card.dart';
import '../controller/entry_controller.dart';

class JournalEntryVoucher extends StatefulWidget {
  const JournalEntryVoucher({super.key});

  @override
  State<JournalEntryVoucher> createState() => _JournalEntryVoucherState();
}

class _JournalEntryVoucherState extends State<JournalEntryVoucher> {
  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;
  final ApiService apiService = ApiService();
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


  // In JournalEntryVoucher class
  Future<void> _saveVoucher() async {
    // Validate that entries exist
    if (voucherController.entries.isEmpty) {
      CustomSnackBar(
          message: 'Please add at least one voucher entry',
          backgroundColor: TColor.third
      ).show();
      return;
    }

    // Validate total debit and credit balance
    if (voucherController.totalDebit.value != voucherController.totalCredit.value) {
      CustomSnackBar(
          message: 'Total Debit and Total Credit must be equal to save',
          backgroundColor: TColor.third
      ).show();
      return;
    }

    setState(() => _isSaving = true);

    try {


      final payload = {
        "voucher_date": selectedDate.toIso8601String().split('T')[0],
        "voucher_detail": voucherController.entries.map((entry) {
          return {
            "cheque_number": entry.cheque,
            "description": entry.description,
            "account_id": entry.account,
            "debit": entry.debit.toString(),
            "credit": entry.credit.toString(),
          };
        }).toList(),
      };

      final response = await apiService.postRequest(
          endpoint: 'journalVoucher',
          body: payload
      );
      // Check for successful response
      if (response['status'] == 'success') {

        Get.back();
        CustomSnackBar(
            message: response['message'] ?? 'Voucher saved successfully',
            backgroundColor: TColor.secondary
        ).show();

        // Clear entries after saving
        voucherController.clearEntries();

      } else {
        CustomSnackBar(
            message: response['message'] ?? 'Failed to save voucher',
            backgroundColor: TColor.third
        ).show();
      }
    } catch (e) {
      // Handle specific exceptions
      String errorMessage = 'An error occurred';
      if (e is UnauthorizedException) {
        errorMessage = 'Unauthorized: Please log in again';
      } else if (e is NetworkException) {
        errorMessage = 'Network error: ${e.message}';
      } else if (e is ServerException) {
        errorMessage = 'Server error: ${e.message}';
      }

      CustomSnackBar(
          message: errorMessage,
          backgroundColor: TColor.third
      ).show();
    } finally {
      setState(() => _isSaving = false);
    }
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
                  textFieldColor: TColor.textField,
                  textColor: TColor.white,
                  placeholderColor: TColor.placeholder,
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveVoucher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
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