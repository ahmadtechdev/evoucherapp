
import 'package:evoucher/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../common/accounts_dropdown.dart';
import '../accounts/accounts/controller/account_controller.dart';
import 'entry_controller.dart';

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

class ReusableEntryCard extends StatefulWidget {
  final bool showImageUpload;
  final Function(double, double)? onTotalChanged;
  final Color primaryColor;
  final Color textFieldColor;
  final Color textColor;
  final Color placeholderColor;
  final bool isViewMode;
  final bool showPrintButton;
  final bool showAddRowButton;
  final List<Map<String, dynamic>>? initialData;

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
  State<ReusableEntryCard> createState() => _ReusableEntryCardState();
}

class _ReusableEntryCardState extends State<ReusableEntryCard> {
  late final AccountsController accountsController;
  late final VoucherController voucherController;
  List<EntryCardData> entries = [];
  double totalDebit = 0.0;
  double totalCredit = 0.0;

  @override
  @override
  void initState() {
    super.initState();
    accountsController = Get.find<AccountsController>();
    voucherController = Get.find<VoucherController>();

    if (voucherController.entries.isNotEmpty) {
      // If controller has existing entries, load them
      for (var controllerEntry in voucherController.entries) {
        var entryData = EntryCardData(
          account: controllerEntry.account,
          description: controllerEntry.description,
          debit: controllerEntry.debit,
          credit: controllerEntry.credit,
        );
        entryData.descriptionController.text = controllerEntry.description;
        entryData.debitController.text = controllerEntry.debit.toString();
        entryData.creditController.text = controllerEntry.credit.toString();
        entries.add(entryData);
      }
    } else {
      _addEntry(); // Add initial empty entry if no existing data
    }
    _calculateTotals();
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
      var entryData = EntryCardData();
      entries.add(entryData);
      voucherController.addEntry(EntryModel(
        account: entryData.account,
        description: entryData.description,
        debit: entryData.debit,
        credit: entryData.credit,
      ));
    });
  }

  void _removeEntry(int index) {
    if (index >= 0 && index < entries.length && entries.length > 1) {
      setState(() {
        final removedEntry = entries[index];
        entries.removeAt(index);
        voucherController.removeEntry(index);
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
            AccountDropdown(
              initialValue: entry.account,
              onChanged: (value) {
                setState(() {
                  entry.account = value ?? '';
                  voucherController.updateEntryData(
                    index,
                    entry.account,
                    entry.description,
                    entry.debit,
                    entry.credit,
                  );
                });
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
                voucherController.updateEntryData(
                  index,
                  entry.account,
                  value,
                  entry.debit,
                  entry.credit,
                );
              },
            ),
            const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: entry.debitController,
                  readOnly: widget.isViewMode,
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
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  enabled: !entry.hasCreditValue,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      entry.debit = value.isEmpty ? 0.0 : double.tryParse(value) ?? 0.0;
                      voucherController.updateEntryData(
                        index,
                        entry.account,
                        entry.description,
                        entry.debit,
                        entry.credit,
                      );
                      _calculateTotals();
                    });
                  },
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextFormField(
                  controller: entry.creditController,
                  readOnly: widget.isViewMode,
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
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  enabled: !entry.hasDebitValue,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      entry.credit = value.isEmpty ? 0.0 : double.tryParse(value) ?? 0.0;
                      voucherController.updateEntryData(
                        index,
                        entry.account,
                        entry.description,
                        entry.debit,
                        entry.credit,
                      );
                      _calculateTotals();
                    });
                  },
                ),
              ),
              if (widget.showImageUpload) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => _pickImage(entry),
                  child: Container(
                    height: 52, // Matches the text field height
                    width: 52, // Optional, creates a square button
                    decoration: BoxDecoration(
                      color: widget.textFieldColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
                    ),
                    child: entry.imageFile != null
                        ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            entry.imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red, size: 16),
                            onPressed: () {
                              setState(() {
                                entry.imageFile = null;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                        : Icon(Icons.add_photo_alternate, color: widget.primaryColor),
                  ),
                ),
              ]

            ],
          ),
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
              color: TColor.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: widget.primaryColor.withOpacity(0.2), width: 2),
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
