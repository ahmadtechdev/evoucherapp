import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Assume these files contain your theme and common widgets.
import '../../common/color_extension.dart';
import '../../common_widget/date_selecter.dart';
import '../../common_widget/round_textfield.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  DateTime fromDate = DateTime(2024, 8, 15);
  DateTime toDate = DateTime(2024, 11, 15);
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateRangeSection(),
            _buildActionButtons(),
            Text(
              'FROM: WED, 08-JAN-2020 | TO: WED, 13-NOV-2024',
              style: TextStyle(
                fontSize: 12,
                color: TColor.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Opening Balance 0 Cr',
              style: TextStyle(
                fontSize: 12,
                color: TColor.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SearchTextField(
              hintText: 'Search transactions...',
              controller: searchController,
              onChange: (value) {
                // Implement search functionality
              },
            ),
            _buildTransactionList(),
            _buildSummaryCard(),
            _buildSummaryDetails(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Ledger of 539 | Adam',
        style: TextStyle(color: TColor.primaryText),
      ),
      backgroundColor: TColor.white,
      elevation: 0.5,
    );
  }

  Widget _buildDateRangeSection() {
    return Container(
      color: TColor.white,

      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: fromDate,
            onDateChanged: (date) => setState(() => fromDate = date),
            label: "FROM:",
          ),
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: toDate,
            onDateChanged: (date) => setState(() => toDate = date),
            label: "TO:  ",
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Row(
        children: [
          _buildActionButton(MdiIcons.microsoftExcel, 'Excel', TColor.primary, () {}),
          _buildActionButton(MdiIcons.printer, 'Print', TColor.third, () {}),
          _buildActionButton(MdiIcons.whatsapp, 'Whatsapp', TColor.secondary, () {}),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: color),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 40,
      itemBuilder: (context, index) => _buildTransactionCard(index),
    );
  }

  Widget _buildTransactionCard(int index) {
    final transaction = _getTransactionData(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 2),
      elevation: 3,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTransactionDetails(transaction),
            _buildTransactionAmounts(transaction),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getTransactionData(int index) {
    return {
      'voucher': 'Voucher ${index + 1}',
      'date': '23 Oct 2024',
      'description': index % 2 == 0 ? 'TEST' : 'RECEIVING',
      'debit': index % 2 == 0 ? 56.00 : 0.00,
      'credit': index % 2 == 0 ? 0.00 : 25000.00,
      'balance': index % 2 == 0 ? 56.00 + index : 24944.00 - index,
      'isCredit': index % 2 != 0
    };
  }

  Widget _buildTransactionDetails(Map<String, dynamic> transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              transaction['voucher'],
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: TColor.secondaryText, size: 14),
                const SizedBox(width: 4),
                Text(
                  transaction['date'],
                  style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          transaction['description'],
          style: TextStyle(color: TColor.secondaryText, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        _buildBalanceInfo(transaction),
      ],
    );
  }

  Widget _buildBalanceInfo(Map<String, dynamic> transaction) {
    return Row(
      children: [
        Icon(Icons.account_balance_wallet, color: TColor.primary, size: 20),
        const SizedBox(width: 4),
        Row(
          children: [
            Text(
              ' ${NumberFormat('#,##0.00').format(transaction['balance'])}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              transaction['isCredit'] ? 'Cr' : 'Dr',
              style: TextStyle(
                color: transaction['isCredit'] ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionAmounts(Map<String, dynamic> transaction) {
    return Column(
      children: [
        _buildAmountBox('Debit', transaction['debit']),
        const SizedBox(height: 6),
        _buildAmountBox('Credit', transaction['credit']),
      ],
    );
  }

  Widget _buildAmountBox(String label, num amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: TColor.secondaryText, fontSize: 10),
          ),
          Text(
            ' ${NumberFormat('#,##0.00').format(amount)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: TColor.primary.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTotalColumn('Total Debit', '76,060.00', Icons.arrow_downward, TColor.third),
              _buildTotalColumn('Total Credit', '25,000.00', Icons.arrow_upward, TColor.secondary),

            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTotalColumn('Closing Balance', '51,060.00 Dr', Icons.account_balance_wallet, TColor.primary, isHighlighted: true),
              _buildWOAccountButton(),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTotalColumn(String label, String value, IconData icon, Color iconColor, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: TColor.secondaryText, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: isHighlighted ? TColor.primary : TColor.primaryText, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWOAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.account_balance, size: 10,),
        label: const Text('W/O Account Now', style: TextStyle(fontSize: 10),),
        style: ElevatedButton.styleFrom(
          backgroundColor: TColor.third,
          foregroundColor: TColor.white,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSummaryDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Summary of Ledger Adam', style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const Divider(height: 1),
          _buildSummaryRow(Icons.account_balance, TColor.primary, 'Opening Balance B/F', '0 Cr'),
          _buildSummaryRow(Icons.add_circle, Colors.green, 'Add Sale Invoice', 'PKR 76,004'),
          _buildSummaryRow(Icons.remove_circle, Colors.red, 'Less Refund Invoices', 'PKR 0'),
          _buildSummaryRow(Icons.remove_circle, Colors.red, 'Less Receipts', 'PKR 25,000'),
          _buildSummaryRow(Icons.add_circle, Colors.green, 'Add Payments', 'PKR 56'),
          const Divider(height: 1),
          _buildSummaryRow(Icons.account_balance_wallet, TColor.primary, 'Net Balance', '51,060 Dr', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, Color iconColor, String label, String value, {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTotal ? TColor.primary.withOpacity(0.05) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: TColor.primaryText, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: isTotal ? TColor.primary : TColor.primaryText, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}