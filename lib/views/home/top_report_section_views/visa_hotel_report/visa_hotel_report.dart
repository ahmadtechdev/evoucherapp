// customer_transaction_screen.dart
import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/date_selecter.dart';
import 'package:evoucher_new/views/home/top_report_section_views/visa_hotel_report/model.dart';
import 'package:evoucher_new/views/home/top_report_section_views/visa_hotel_report/visa_hotel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../side_bar/accounts/accounts_ledger/view_accounts_ledger.dart';

class VisaHotelReport extends StatelessWidget {
  final VisaHotelController controller = Get.put(VisaHotelController());

  VisaHotelReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        foregroundColor: TColor.white,
        centerTitle: true,
        title: Text(
          'Visa & Hotel Report',
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
                  initialDate: controller.selectedDate.value,
                  label: "DATE:",
                  onDateChanged: (newDate) {
                    controller.updateDate(newDate);
                  },
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.isLoading.value) {
              // Show loading indicator
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.transactions.isEmpty) {
              // Show "No records found" message
              return const Expanded(
                child: Center(
                  child: Text(
                    "No records found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            } else {
              // Show the transaction list
              return _buildTransactionList();
            }
          }),
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return _TransactionCard(
            visaHotel: transaction,
            controller: controller,
          );
        },
      ),
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
                label: "Total Debit",
                amount: controller.totalReceipt.value,
                color: TColor.primary,
              ),
              _SummaryItem(
                label: "Total Credit",
                amount: controller.totalPayment.value,
                color: TColor.secondary,
              ),
              _SummaryItem(
                label: "Total",
                amount: controller.closingBalance.value,
                color: TColor.fourth,
              ),
            ],
          )),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final VisaHotel visaHotel;
  final VisaHotelController controller;

  const _TransactionCard({
    required this.visaHotel,
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
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visaHotel.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
                Text(
                  "#${visaHotel.id}",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                      controller.currencyFormatter.format(visaHotel.closingDr),
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.third,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Credit",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      controller.currencyFormatter.format(visaHotel.closingCr),
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
            if (visaHotel.contact != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: TColor.primary),
                  const SizedBox(width: 8),
                  Text(
                    visaHotel.contact!,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.book,
                    label: "Ledger",
                    color: TColor.primary,
                    onPressed: () {
                      Get.to(() => LedgerScreen(
                        accountId: visaHotel.id,
                        accountName: visaHotel.name,
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                if (visaHotel.contact != null)
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.call,
                      label: "WhatsApp",
                      color: TColor.secondary,
                      onPressed: () =>
                          controller.openWhatsApp(visaHotel.contact!),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Apply background color with opacity
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: TextStyle(color: color),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove extra padding from the TextButton
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
          NumberFormat("#,##0.0", "en_US").format(amount),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
