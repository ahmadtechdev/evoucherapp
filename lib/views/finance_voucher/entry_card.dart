import 'package:dropdown_search/dropdown_search.dart';
import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/common_widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../accounts/accounts/accounts_provider.dart';

class EntryCardData {
  String account;
  String description;
  double debit;
  double credit;
  File? imageFile;
  final String id;
  final TextEditingController descriptionController;
  final TextEditingController debitController;
  final TextEditingController creditController;

  EntryCardData({
    this.account = '',
    this.description = '',
    this.debit = 0.0,
    this.credit = 0.0,
    this.imageFile,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        descriptionController = TextEditingController(text: ''),
        debitController = TextEditingController(text: ''),
        creditController = TextEditingController(text: '');

  void dispose() {
    descriptionController.dispose();
    debitController.dispose();
    creditController.dispose();
  }

  bool get hasDebitValue => debit > 0 || debitController.text.isNotEmpty;

  bool get hasCreditValue => credit > 0 || creditController.text.isNotEmpty;
}

class ReusableEntryCard extends ConsumerStatefulWidget {
  final bool showImageUpload;

  final Function(double, double)? onTotalChanged;
  final Color primaryColor;
  final Color textFieldColor;
  final Color textColor;
  final Color placeholderColor;
  final bool isViewMode; // New property
  final bool showPrintButton; // New property
  final bool showAddRowButton; // New property
  final List<Map<String, dynamic>>? initialData;
  // New property

  const ReusableEntryCard({
    super.key,
    this.showImageUpload = false,
    this.onTotalChanged,
    this.primaryColor = const Color(0xFF2196F3),
    this.textFieldColor = const Color(0xFFF5F5F5),
    this.textColor = Colors.white,
    this.placeholderColor = const Color(0xFF9E9E9E),
    this.isViewMode = false,
    this.showPrintButton = false,
    this.showAddRowButton = false,
    this.initialData,
  });

  @override
  ConsumerState<ReusableEntryCard> createState() => _ReusableEntryCardState();
}

class _ReusableEntryCardState extends ConsumerState<ReusableEntryCard> {
  List<EntryCardData> entries = [];
  double totalDebit = 0.0;
  double totalCredit = 0.0;

  @override
  void initState() {
    super.initState();
    // Start with one entry
    _addEntry();
  }

  @override
  void dispose() {
    for (var entry in entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() {
      entries.add(EntryCardData());
       });
    }

  void _removeEntry(int index) {
    if (index >= 0 && index < entries.length && entries.length > 1) {
      setState(() {
        final removedEntry = entries[index];
        entries.removeAt(index);
        removedEntry.dispose();
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    double newTotalDebit = 0.0;
    double newTotalCredit = 0.0;

    for (var entry in entries) {
      newTotalDebit += entry.debit;
      newTotalCredit += entry.credit;
    }

    setState(() {
      totalDebit = newTotalDebit;
      totalCredit = newTotalCredit;
    });

    // Notify parent of total changes if callback is provided
    widget.onTotalChanged?.call(totalDebit, totalCredit);
  }

  Future<void> _pickImage(EntryCardData entry) async {
    if (!widget.isViewMode) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            entry.imageFile = File(image.path);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error picking image: $e')),
          );
        }
      }
    }
  }

  Widget _buildPrintButton(EntryCardData entry) {
    if (!widget.showPrintButton) return const SizedBox();

    return TextButton.icon(
      icon: Icon(Icons.print, color: TColor.white),
      label: Text(
        entry.hasDebitValue ? 'Receipt Print' : 'Payment Print',
        style: TextStyle(color: TColor.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: entry.hasDebitValue
            ? TColor.secondary // Green for Receipt Print
            : TColor.third, // Red for Payment Print
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Implement print functionality
      },
    );
  }

  Widget _buildEntryCard(EntryCardData entry, int index) {
    final accountsAsyncValue = ref.watch(accountsDataProvider);

    return Card(
      key: ValueKey(entry.id),
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: 2,
      color: widget.primaryColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry ${index + 1}',
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (index > 0)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 18),
                    onPressed: () => _removeEntry(index),


                  ),
              ],
            ),
            const SizedBox(height: 4),
            accountsAsyncValue.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Text('Error loading accounts: $err'),
              ),
              data: (accounts) {
                final accountNames =
                    accounts.map((account) => account.name).toList();
                return DropdownSearch<String>(
                  enabled: !widget.isViewMode,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search account...",
                        prefixIcon:
                            Icon(Icons.search, color: widget.placeholderColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: widget.textFieldColor,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 1.5,
                    ),
                    showSelectedItems: true,
                    searchDelay: const Duration(milliseconds: 300),
                  ),
                  items: accountNames,
                  selectedItem: entry.account.isEmpty ? null : entry.account,
                  onChanged: (value) {
                    setState(() {
                      entry.account = value ?? '';
                    });
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: widget.textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Select an account',
                      hintStyle: const TextStyle(
                        fontSize: 14
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: entry.descriptionController,
              readOnly: widget.isViewMode ? true : false,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Description',
                hintStyle: TextStyle(color: widget.placeholderColor),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onChanged: (value) {
                entry.description = value;
              },
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: entry.debitController,
                    readOnly: widget.isViewMode ? true : false,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: entry.hasCreditValue
                          ? widget.textFieldColor.withOpacity(0.5)
                          : widget.textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Debit',
                      hintStyle: TextStyle(
                          color: entry.hasCreditValue
                              ? widget.placeholderColor.withOpacity(0.5)
                              : widget.placeholderColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    enabled: !entry.hasCreditValue,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          entry.debit = 0.0;
                        } else {
                          entry.debit = double.tryParse(value) ?? 0.0;
                        }
                        _calculateTotals();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextFormField(
                    controller: entry.creditController,
                    readOnly: widget.isViewMode ? true : false,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: entry.hasDebitValue
                          ? widget.textFieldColor.withOpacity(0.5)
                          : widget.textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Credit',
                      hintStyle: TextStyle(
                          color: entry.hasDebitValue
                              ? widget.placeholderColor.withOpacity(0.5)
                              : widget.placeholderColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    enabled: !entry.hasDebitValue,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          entry.credit = 0.0;
                        } else {
                          entry.credit = double.tryParse(value) ?? 0.0;
                        }
                        _calculateTotals();
                      });
                    },
                  ),
                ),
              ],
            ),
            if (widget.showImageUpload) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: widget.textFieldColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: widget.primaryColor.withOpacity(0.2)),
                      ),
                      child: entry.imageFile != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    entry.imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        entry.imageFile = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => _pickImage(entry),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 32, color: widget.primaryColor),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add Image',
                                    style: TextStyle(
                                      color: widget.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
            if (widget.showPrintButton)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildPrintButton(entry),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
            ),
            height: MediaQuery.of(context).size.height/1.9,
            child: ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) =>
                  _buildEntryCard(entries[index], index),
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (widget.showAddRowButton || !widget.isViewMode)
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: ElevatedButton(
              onPressed: _addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.fourth,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: TColor.primaryText,
                  ),
                  Text(
                    'Add Row',
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        if (widget.showAddRowButton || !widget.isViewMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: widget.primaryColor.withOpacity(0.2), width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Debit',
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.bold)),
                    Text(
                      totalDebit.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Credit',
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.bold)),
                    Text(
                      totalCredit.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Difference',
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.bold)),
                    Text(
                      (totalDebit - totalCredit).toStringAsFixed(2),
                      style: TextStyle(
                        color: totalDebit == totalCredit
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

      ],
    );
  }
}
