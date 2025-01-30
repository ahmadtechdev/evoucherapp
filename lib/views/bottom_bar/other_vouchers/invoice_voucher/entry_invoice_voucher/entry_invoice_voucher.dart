import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/round_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryInvoiceVoucher extends StatefulWidget {
  const EntryInvoiceVoucher({Key? key}) : super(key: key);

  @override
  State<EntryInvoiceVoucher> createState() => _EntryInvoiceVoucherState();
}

class _EntryInvoiceVoucherState extends State<EntryInvoiceVoucher> {
  final List<InvoiceRow> rows = [InvoiceRow()];
  DateTime selectedDate = DateTime.now();
  final TextEditingController partyController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  double total = 0.0;

  void _addRow() {
    setState(() {
      rows.add(InvoiceRow());
    });
  }

  void _removeRow(int index) {
    if (rows.length > 1) {
      setState(() {
        rows.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Entry Vouchers'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Selection
              RoundTitleTextfield(
                title: 'Date',
                hintText: DateFormat('MMM dd, yyyy').format(selectedDate),
                readOnly: true,
                left: Icon(Icons.calendar_today, color: TColor.secondaryText),
                right: IconButton(
                  icon:
                      Icon(Icons.arrow_drop_down, color: TColor.secondaryText),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Account Selection
              Row(
                children: [
                  Expanded(
                    child: RoundTitleTextfield(
                      controller: partyController,
                      title: 'Party Account',
                      hintText: 'Select Account',
                      left: Icon(Icons.account_balance,
                          color: TColor.secondaryText),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RoundTitleTextfield(
                      controller: creditController,
                      title: 'Credit Account',
                      hintText: 'Select Account',
                      left: Icon(Icons.account_balance_wallet,
                          color: TColor.secondaryText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Invoice Rows
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Entry #${index + 1}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: TColor.secondary,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: TColor.third),
                                onPressed: () => _removeRow(index),
                              )
                            ],
                          ),
                          Divider(
                              color: TColor.secondary.withOpacity(0.2),
                              height: 30),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: RoundTitleTextfield(
                                  controller: rows[index].descriptionController,
                                  title: 'Description',
                                  hintText: 'Enter Description',
                                  left: Icon(Icons.description,
                                      color: TColor.secondaryText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RoundTitleTextfield(
                                  controller: rows[index].qtyController,
                                  title: 'QTY',
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  left: Icon(Icons.numbers,
                                      color: TColor.secondaryText),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RoundTitleTextfield(
                                  controller: rows[index].rateController,
                                  title: 'Rate',
                                  hintText: '0.00',
                                  keyboardType: TextInputType.number,
                                  left: Icon(Icons.currency_rupee,
                                      color: TColor.secondaryText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RoundTitleTextfield(
                                  controller: rows[index].amountController,
                                  title: 'ex Amount',
                                  hintText: '0.00',
                                  readOnly: true,
                                  left: Icon(Icons.calculate,
                                      color: TColor.secondaryText),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RoundTitleTextfield(
                                  controller: rows[index].discountController,
                                  title: 'Disc%',
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  left: Icon(Icons.discount,
                                      color: TColor.secondaryText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RoundTitleTextfield(
                                  controller: rows[index].gstController,
                                  title: 'GST%',
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  left: Icon(Icons.percent,
                                      color: TColor.secondaryText),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RoundTitleTextfield(
                            controller: rows[index].amountController,
                            title: 'Amount',
                            hintText: '0.00',
                            readOnly: true,
                            left: Icon(Icons.calculate,
                                color: TColor.secondaryText),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Add Button
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: _addRow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.fourth,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 4,
                    ),
                    child: Icon(Icons.add, color: TColor.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Summary Card
              Container(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _buildSummaryRow(
                      'Total Amount:', '₹${calculateTotal()}', TColor.primary),
                ]),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {/* Implement save functionality */},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double calculateTotal() {
    return rows.fold(0.0, (sum, row) => sum + row.calculateAmount());
  }
}

class InvoiceRow {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController qtyController = TextEditingController(text: '0');
  final TextEditingController rateController = TextEditingController(text: '0');
  final TextEditingController amountController =
      TextEditingController(text: '0');
  final TextEditingController discountController =
      TextEditingController(text: '0');
  final TextEditingController gstController = TextEditingController(text: '0');

  double calculateAmount() {
    double qty = double.tryParse(qtyController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;
    double gst = double.tryParse(gstController.text) ?? 0;

    double amount = qty * rate;
    amount -= (amount * discount / 100);
    amount += (amount * gst / 100);

    amountController.text = amount.toStringAsFixed(2);
    return amount;
  }
}
