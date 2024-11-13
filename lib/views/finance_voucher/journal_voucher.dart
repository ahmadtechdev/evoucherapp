import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/date_selecter.dart';


class JournalEntry {
  String account;
  String description;
  double debit;
  double credit;
  final String id;
  final TextEditingController descriptionController;
  final TextEditingController debitController;
  final TextEditingController creditController;

  JournalEntry({
    this.account = '',
    this.description = '',
    this.debit = 0.0,
    this.credit = 0.0,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
        descriptionController = TextEditingController(text: ''),
        debitController = TextEditingController(text: ''),
        creditController = TextEditingController(text: '');

  void dispose() {
    descriptionController.dispose();
    debitController.dispose();
    creditController.dispose();
  }
}

class JournalVoucher extends StatefulWidget {
  const JournalVoucher({super.key});

  @override
  State<JournalVoucher> createState() => _JournalVoucherState();
}

class _JournalVoucherState extends State<JournalVoucher> {
  DateTime selectedDate = DateTime.now();
  List<JournalEntry> entries = [JournalEntry()];
  double totalDebit = 0.0;
  double totalCredit = 0.0;
  final FocusNode _mainFocusNode = FocusNode();

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
  void dispose() {
    _mainFocusNode.dispose();
    for (var entry in entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() {
      entries.add(JournalEntry());
    });
  }

  void _removeEntry(int index) {
    if (index >= 0 && index < entries.length) {
      final removedEntry = entries[index];
      setState(() {
        entries.removeAt(index);
        removedEntry.dispose();
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    setState(() {
      totalDebit = entries.fold(0, (sum, entry) => sum + entry.debit);
      totalCredit = entries.fold(0, (sum, entry) => sum + entry.credit);
    });
  }

  Widget _buildEntryCard(int index) {
    final entry = entries[index];
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text fields
        FocusScope.of(context).requestFocus(_mainFocusNode);
      },
      child: Card(
        key: ValueKey(entry.id),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        color: TColor.primary.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Entry ${index + 1}',
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (entries.length > 1 && index > 0) // Only show cross if index > 0
                    IconButton(
                      icon: Icon(Icons.close, color: TColor.third),
                      onPressed: () => _removeEntry(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    autofocus: true,  // Auto focus search field
                    decoration: InputDecoration(
                      hintText: "Search account...",
                      prefixIcon: Icon(Icons.search, color: TColor.placeholder),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: TColor.textfield,
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 1.5,  // screen height with 20px padding on top and bottom
                  ),
                  showSelectedItems: true,
                  searchDelay: const Duration(milliseconds: 300),
                ),
                items: accounts,
                selectedItem: entry.account.isEmpty ? null : entry.account,
                onChanged: (value) {
                  setState(() {
                    entry.account = value ?? '';
                  });
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor: TColor.textfield,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Select an account',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: entry.descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TColor.textfield,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Description',
                  hintStyle: TextStyle(color: TColor.placeholder),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  entry.description = value;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: entry.debitController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TColor.textfield,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Debit',
                        hintStyle: TextStyle(color: TColor.placeholder),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          entry.debit = double.tryParse(value) ?? 0.0;
                          _calculateTotals();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: entry.creditController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TColor.textfield,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Credit',
                        hintStyle: TextStyle(color: TColor.placeholder),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          entry.credit = double.tryParse(value) ?? 0.0;
                          _calculateTotals();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) => _buildEntryCard(index),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: screenWidth/3,
                    child: ElevatedButton(
                      onPressed: _addEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.fourth,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Add Row',
                        style: TextStyle(
                         color: TColor.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Debit',
                              style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold)),
                          Text(
                            totalDebit.toStringAsFixed(2),
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Credit',
                              style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold)),
                          Text(
                            totalCredit.toStringAsFixed(2),
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24, color: TColor.textfield),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Difference',
                              style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold)),
                          Text(
                            (totalDebit - totalCredit).toStringAsFixed(2),
                            style: TextStyle(
                              color: totalDebit >= totalCredit
                                  ? TColor.secondary
                                  : TColor.third,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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