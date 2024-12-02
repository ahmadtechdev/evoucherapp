import 'dart:io';

import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_textfield.dart';
import '../../../service/api_service.dart';
import 'ledger_controller.dart';
import 'ledger_modal.dart';
import 'package:flutter/material.dart';

class LedgerScreen extends StatelessWidget {
  final String accountId;
  final String accountName;

  const LedgerScreen({
    super.key,
    required this.accountId,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with dependency injection
    final LedgerController controller = Get.put(
        LedgerController(
            accountId: accountId,
            accountName: accountName
        )
    );

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }

        if (controller.masterData.value == null) {
          return const Center(child: Text('No data available'));
        }

        final masterData = controller.masterData.value!;
        final vouchers = controller.filteredVouchers;

        // Calculate totals
        double totalDebit = controller.calculateTotalDebit();
        double totalCredit = controller.calculateTotalCredit();

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildDateRangeSection(controller),
              _buildActionButtons(context, controller),
              Text(
                'FROM: ${DateFormat('EEE, dd-MMM-yyyy').format(controller.fromDate.value)} | TO: ${DateFormat('EEE, dd-MMM-yyyy').format(controller.toDate.value)}',
                style: TextStyle(
                  fontSize: 12,
                  color: TColor.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Opening Balance ${masterData.opening}',
                style: TextStyle(
                  fontSize: 12,
                  color: TColor.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SearchTextField(
                hintText: 'Search transactions...',
                onChange: controller.searchTransactions,
              ),
              _buildTransactionList(vouchers),
              _buildSummaryCard(totalDebit, totalCredit, masterData.closing),
              _buildSummaryDetails(masterData),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          'Ledger of $accountId | $accountName',
          style: TextStyle(color: TColor.primaryText),
        ),
      ),
      backgroundColor: TColor.white,
      elevation: 0.5,
    );
  }

  Widget _buildDateRangeSection(LedgerController controller) {
    return Container(
      color: TColor.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: controller.fromDate.value,
            onDateChanged: (date) {
              controller.updateDateRange(date, controller.toDate.value);
            },
            label: "FROM:",
          ),
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: controller.toDate.value,
            onDateChanged: (date) {
              controller.updateDateRange(controller.fromDate.value, date);
            },
            label: "TO:  ",
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LedgerController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Row(
        children: [
          _buildActionButton(
              MdiIcons.microsoftExcel, 'Excel', TColor.primary,
                  () => _exportToExcel(context, controller.filteredVouchers)),
          _buildActionButton(MdiIcons.printer, 'Print', TColor.third, () {}),
          _buildActionButton(
              MdiIcons.whatsapp, 'Whatsapp', TColor.secondary, launchWhatsappWithMobileNumber),
        ],
      ),
    );
  }

  void _exportToExcel(BuildContext context, List<LedgerVoucher> vouchers) async {
    // Excel export logic remains the same as in the original file
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow([
      TextCellValue('Voucher'),
      TextCellValue('Date'),
      TextCellValue('Description'),
      TextCellValue('Debit'),
      TextCellValue('Credit'),
      TextCellValue('Balance'),
    ]);

    for (var voucher in vouchers) {
      sheet.appendRow([
        TextCellValue(voucher.voucher),
        TextCellValue(voucher.date),
        TextCellValue(voucher.description),
        DoubleCellValue(voucher.debit),
        DoubleCellValue(voucher.credit),
        TextCellValue(voucher.balance),
      ]);
    }

    String downloadsPath = '/storage/emulated/0/Download';
    String filePath = '$downloadsPath/ledger_$accountId.xlsx';

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file exported to $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export Excel file')),
      );
    }
  }

  Future<void> launchWhatsappWithMobileNumber() async {
    String message = "Journey Online Message";
    String mobileNumber = "923027253781";
    final url = "https://wa.me/$mobileNumber?text=$message";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildTransactionList(List<LedgerVoucher> vouchers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) => _buildTransactionCard(vouchers[index]),
    );
  }

  Widget _buildTransactionCard(LedgerVoucher voucher) {
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
            _buildTransactionDetails(voucher),
            _buildTransactionAmounts(voucher),
          ],
        ),
      ),
    );
  }


  Widget _buildTransactionDetails(LedgerVoucher voucher) {
    bool isCredit = voucher.balance.toLowerCase().contains('cr');

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  voucher.voucher,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: TColor.secondaryText, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(voucher.date)),
                      style:
                      TextStyle(color: TColor.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              voucher.description,
              style: TextStyle(color: TColor.secondaryText, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: TColor.primary, size: 20),
                const SizedBox(width: 4),
                Text(
                  voucher.balance,
                  style: TextStyle(
                    color: isCredit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTransactionAmounts(LedgerVoucher voucher) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          _buildAmountBox('Debit', voucher.debit),
          const SizedBox(height: 6),
          _buildAmountBox('Credit', voucher.credit),
        ],
      ),
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

  Widget _buildSummaryCard(
      double totalDebit, double totalCredit, String closing) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalColumn('Total Debit', totalDebit.toString(),
                      Icons.arrow_downward, TColor.third),
                  const SizedBox(width: 20),
                  _buildTotalColumn('Total Credit', totalCredit.toString(),
                      Icons.arrow_upward, TColor.secondary),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalColumn('Closing Balance', closing.toString(),
                      Icons.account_balance_wallet, TColor.primary,
                      isHighlighted: true),
                  const SizedBox(width: 20),
                  _buildWOAccountButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalColumn(
      String label, String value, IconData icon, Color iconColor,
      {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(color: TColor.secondaryText, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: isHighlighted ? TColor.primary : TColor.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ],
    );
  }


  Widget _buildWOAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.account_balance,
          size: 10,
        ),
        label: const Text(
          'W/O Account Now',
          style: TextStyle(fontSize: 10),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: TColor.third,
          foregroundColor: TColor.white,
        ),
        onPressed: () {},
      ),
    );
  }


  Widget _buildSummaryDetails(LedgerMasterData masterData) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: TColor.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Summary of Ledger Adam',
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              const Divider(height: 1),
              _buildSummaryRow(Icons.account_balance, TColor.primary,
                  'Opening Balance B/F', masterData.opening),
              _buildSummaryRow(Icons.add_circle, Colors.green,
                  'Add Sale Invoice', 'PKR 76,004 -d'),
              _buildSummaryRow(Icons.remove_circle, Colors.red,
                  'Less Refund Invoices', 'PKR 0 -d'),
              _buildSummaryRow(Icons.remove_circle, Colors.red, 'Less Receipts',
                  'PKR 25,000 -d'),
              _buildSummaryRow(
                  Icons.add_circle, Colors.green, 'Add Payments', 'PKR 56 -d'),
              const Divider(height: 1),
              _buildSummaryRow(Icons.account_balance_wallet, TColor.primary,
                  'Net Balance', '51,060 Dr -d',
                  isTotal: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      IconData icon, Color iconColor, String label, String value,
      {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTotal ? TColor.primary.withOpacity(0.05) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Text(
            value,
            style: TextStyle(
                color: isTotal ? TColor.primary : TColor.primaryText,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(foregroundColor: color),
    );
  }
// Rest of the methods remain the same as in the original file
// _buildTransactionList, _buildTransactionCard, _buildSummaryCard, etc.
// Refer to the original file for their implementation
}