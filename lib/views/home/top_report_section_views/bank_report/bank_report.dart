import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/date_selecter.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/bank_report_controller.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BanksScreen extends StatelessWidget {
  final BanksController controller = Get.put(BanksController());

  BanksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        foregroundColor: TColor.white,
        centerTitle: true,
        title: Text(
          'Banks Report',
          style: TextStyle(color: TColor.white),
        ),
        backgroundColor: TColor.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateSelector(
                  fontSize: 14,
                  vpad: 20,
                  initialDate: DateTime.now(),
                  label: "DATE:",
                  onDateChanged: (newDate) {},
                ),
              ),
            ],
          ),
          _buildBanksList(),
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildBanksList() {
    return Expanded(
      child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.banks.length,
            itemBuilder: (context, index) {
              final bank = controller.banks[index];
              return _BankCard(
                bank: bank,
                controller: controller,
              );
            },
          )),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: TColor.secondaryText.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                label: "Total Receipt",
                amount: controller.totalReceipt.value,
                color: TColor.primary,
              ),
              _SummaryItem(
                label: "Total Payment",
                amount: controller.totalPayment.value,
                color: TColor.secondary,
              ),
              _SummaryItem(
                label: "Closing Balance",
                amount: controller.closingBalance.value,
                color: TColor.fourth,
              ),
            ],
          )),
    );
  }
}

class _BankCard extends StatelessWidget {
  final Bank bank;
  final BanksController controller;

  const _BankCard({
    required this.bank,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bank.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColor.primaryText,
                        ),
                      ),
                      if (bank.accountNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          bank.accountNumber!,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "#${bank.id}",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Debit",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      controller.currencyFormatter.format(bank.closingDr),
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.third,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Credit",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      controller.currencyFormatter.format(bank.closingCr),
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => controller.openLedger(bank.id),
                icon: Icon(Icons.book, size: 18, color: TColor.primary),
                label: Text(
                  'View Ledger',
                  style: TextStyle(color: TColor.primary),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: TColor.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          NumberFormat("#,##0.00", "en_US").format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
