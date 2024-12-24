import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../../../common_widget/snackbar.dart';
import '../widgets/entry_card.dart';
import '../controller/entry_controller.dart';

class BankEntryVoucher extends StatefulWidget {
  const BankEntryVoucher({super.key});

  @override
  State<BankEntryVoucher> createState() => _BankEntryVoucherState();
}

class _BankEntryVoucherState extends State<BankEntryVoucher> {
  DateTime selectedDate = DateTime.now();
  late final VoucherController _voucherController;
  bool _isSaving = false;
  // final ApiService _apiService = ApiService();
  double totalDebit = 0.0;
  double totalCredit = 0.0;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Use Get.find instead of Get.put to ensure the controller is already registered
    _voucherController = Get.find<VoucherController>();

    // Clear any existing entries when the page is first loaded
    _voucherController.clearEntries();
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveVoucher() async {
    // Validate that entries exist
    if (_voucherController.entries.isEmpty) {
      CustomSnackBar(
          message: 'Please add at least one voucher entry',
          backgroundColor: TColor.third
      ).show();
      return;
    }

    // Validate total debit and credit balance
    if (_voucherController.totalDebit.value != _voucherController.totalCredit.value) {
      CustomSnackBar(
          message: 'Total Debit and Total Credit must be equal to save',
          backgroundColor: TColor.third
      ).show();
      return;
    }

    setState(() => _isSaving = true);

    try {
      // API Service Implementation
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final payload = {
        "voucher_date": selectedDate.toIso8601String().split('T')[0],
        "voucher_detail": _voucherController.entries.map((entry) {
          return {
            "cheque_number": entry.cheque,
            "description": entry.description,
            "account_id": entry.account,
            "debit": entry.debit.toString(),
            "credit": entry.credit.toString(),
          };
        }).toList(),
      };

      var request = http.Request('POST', Uri.parse('https://evoucher.pk/api-new/bankVoucher'));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // Parse the response
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      // Check for successful response
      if (response.statusCode == 200) {
        // Assuming the API returns a status and message
        if (responseData['status'] == 'success') {
          CustomSnackBar(
              message: responseData['message'] ?? 'Voucher saved successfully',
              backgroundColor: TColor.secondary
          ).show();

          // Clear entries after saving
          _voucherController.clearEntries();

          // Navigate back or clear the form
          Get.back();
        } else {
          CustomSnackBar(
              message: responseData['message'] ?? 'Failed to save voucher',
              backgroundColor: TColor.third
          ).show();
        }
      } else {
        // Handle non-200 status codes
        CustomSnackBar(
            message: 'Error: ${responseData['message'] ?? 'Server error'}',
            backgroundColor: TColor.third
        ).show();
      }
    } catch (e) {
      // Handle any network or parsing errors
      CustomSnackBar(
          message: 'Error: ${e.toString()}',
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
                  showChequeField: true,
                  onTotalChanged: (totalDebit, totalCredit) {
                    // Optional: Handle total changes in parent widget
                    print('Total Debit: \$totalDebit, Total Credit: \$totalCredit');
                  },
                ),
                SizedBox(height: screenHeight * 0.02), // 2% of screen height
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6, // 60% of screen width
                    child: // In your build method, update the Save button:
                    ElevatedButton(
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

