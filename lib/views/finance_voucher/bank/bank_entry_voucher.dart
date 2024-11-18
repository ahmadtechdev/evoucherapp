import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/date_selecter.dart';
import '../../../common_widget/snackbar.dart';
import '../entry_card.dart';
import 'bank_voucher_provider.dart';

class BankEntryVoucher extends ConsumerStatefulWidget {
  const BankEntryVoucher({super.key});

  @override
  ConsumerState<BankEntryVoucher> createState() => _BankEntryVoucherState();
}

class _BankEntryVoucherState extends ConsumerState<BankEntryVoucher> {
  bool _isSaving = false;
  late final ReusableEntryCard _entryCard;
  DateTime selectedDate = DateTime.now();
  double totalDebit = 0.0;
  double totalCredit = 0.0;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _entryCard = ReusableEntryCard(
      showImageUpload: true,
      showChequeField: true,
      primaryColor: TColor.primary,
      textFieldColor: TColor.textfield,
      textColor: TColor.white,
      placeholderColor: TColor.placeholder,
      onTotalChanged: (debit, credit) {
        setState(() {
          totalDebit = debit;
          totalCredit = credit;
        });
      },
    );
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    CustomSnackBar(
      message: message,
      backgroundColor: Colors.red,
    ).show(context);
  }


  void _showSuccessSnackbar(String message) {
    if (!mounted) return;

    CustomSnackBar(
      message: message,
      backgroundColor: Colors.green,
    ).show(context);
  }

  List<Map<String, dynamic>> _getEntries() {
    final entries = <Map<String, dynamic>>[];

    // Access entries using the new getter
    for (var entry in _entryCard.currentEntries) {
      if (entry.account.isNotEmpty && (entry.debit > 0 || entry.credit > 0)) {
        final entryMap = {
          'account_id': entry.account,
          'description': entry.descriptionController.text,
          'debit': entry.debit,
          'credit': entry.credit,
        };

        // Add cheque number if present
        if (entry.chequeController.text.isNotEmpty) {
          entryMap['cheque_no'] = entry.chequeController.text;
        }

        entries.add(entryMap);
      }
    }

    return entries;
  }

  Future<void> _saveVoucher() async {
    if (_isSaving) return;

    // Validate totals match
    final difference = totalDebit - totalCredit;
    if (difference.abs() > 0.001) { // Handling floating-point precision
      _showErrorSnackbar('Debit and Credit must be equal');
      return;
    }

    // Get and validate entries
    final entries = _getEntries();
    if (entries.isEmpty) {
      _showErrorSnackbar('Please add at least one entry');
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Debugging: Log the request data
      print('Saving voucher with date: $selectedDate');
      print('Entries: $entries');

      // Submit voucher using the provider
      await ref.read(bankVoucherProvider.notifier).submitVoucher(
        date: selectedDate.toString(),
        entries: entries,
      );

      // Show success snackbar and navigate back if successful
      _showSuccessSnackbar('Bank Voucher saved successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error snackbar and log the error
      _showErrorSnackbar('Failed to save voucher: $e');
      print('Error saving voucher: $e');
    } finally {
      // Reset saving state
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_mainFocusNode),
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
                // Date Selector
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

                // Entry Card
                _entryCard,
                const SizedBox(height: 24),

                // Save Button
                Center(
                  child: SizedBox(
                    width: screenWidth / 1.5,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveVoucher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              TColor.white),
                        ),
                      )
                          : Text(
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