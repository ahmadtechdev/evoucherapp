import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class JournalEntry {
  String account;
  String description;
  double debit;
  double credit;

  JournalEntry({
    this.account = '',
    this.description = '',
    this.debit = 0.0,
    this.credit = 0.0,
  });
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: TColor.white,
              surface: TColor.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addEntry() {
    setState(() {
      entries.add(JournalEntry());
    });
  }

  void _removeEntry(int index) {
    setState(() {
      entries.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    totalDebit = entries.fold(0, (sum, entry) => sum + entry.debit);
    totalCredit = entries.fold(0, (sum, entry) => sum + entry.credit);
    setState(() {});
  }

  Widget _buildEntryCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
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
                      color: TColor.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (entries.length > 1)
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
                constraints: BoxConstraints(maxHeight: 400),
                showSelectedItems: true,
                searchDelay: const Duration(milliseconds: 300),
              ),
              items: accounts,
              selectedItem: entries[index].account.isEmpty
                  ? null
                  : entries[index].account,
              onChanged: (value) {
                setState(() {
                  entries[index].account = value ?? '';
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
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
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
                entries[index].description = value;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                      entries[index].debit = double.tryParse(value) ?? 0.0;
                      _calculateTotals();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
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
                      entries[index].credit = double.tryParse(value) ?? 0.0;
                      _calculateTotals();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: TColor.textfield,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MM/dd/yyyy').format(selectedDate),
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: TColor.primary),
                    ],
                  ),
                ),
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
                    width: screenWidth / 2,
                    child: RoundButton(
                      title: "Add Entry",
                      onPressed: _addEntry,
                      color: TColor.third,
                    )),
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
                  width: screenWidth / 2,
                  child: RoundButton(
                    title: 'Save',
                    onPressed: () {},
                    color: TColor.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}