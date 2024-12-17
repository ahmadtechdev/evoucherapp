import 'package:evoucher/common/accounts_dropdown.dart';
import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/common/drawer.dart';
import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:evoucher/views/side_bar/invoice_settlement/settle_invoice/single_invoice_settle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/invoice_settlement_controller.dart';


class InvoiceSettlement extends StatelessWidget {
  const InvoiceSettlement({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceSettlementController controller = Get.put(InvoiceSettlementController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Invoice Settlement'),
      ),
      drawer: const CustomDrawer(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDateRangeSection(controller),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AccountDropdown(
                  primaryColor: TColor.secondary,
                  isEnabled: true,
                  onChanged: (selectedAccount) {
                    controller.setAccount(selectedAccount!);
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildInvoiceRows(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSection(InvoiceSettlementController controller) {
    return Container(
      color: TColor.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: controller.dateFrom.value,
            onDateChanged: (date) {
              controller.setDateRange(date, controller.dateTo.value);
            },
            label: "FROM:",
          ),
          const SizedBox(width: 18),
          DateSelector2(
            fontSize: 14,
            initialDate: controller.dateTo.value,
            onDateChanged: (date) {
              controller.setDateRange(controller.dateFrom.value, date);
            },
            label: "TO:  ",
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRows() {
    return Column(
      children: [
        _buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: true,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: false,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: true,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: false,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: false,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: true,
        ),_buildInvoiceRow(
          voucherId: 'CV-329',
          dated: 'Fri, 04 Aug 2023',
          description: 'CASH RECEIVED FROM AFAQ TRAVEL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 0',
          remainingAmount: 'PKR 50,000',
          isSettled: false,
        ),
        _buildInvoiceRow(
          voucherId: 'BV-401',
          dated: 'Thu, 17 Aug 2023',

          description: 'AFAQ TRAVEL PAYMENT RECEIVED IN HBL',
          totalAmount: 'PKR 50,000',
          settledAmount: 'PKR 235234',
          remainingAmount: 'PKR 50,000',
          isSettled: true,
        ),
        // Add more invoice rows as needed
      ],
    );
  }

  Widget _buildInvoiceRow({
    required String voucherId,
    required String dated,
    required String description,
    required String totalAmount,
    required String settledAmount,
    required String remainingAmount,
    required bool isSettled,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const SingleInvoiceSettlementPage());
        },
        child: Card(
          elevation: 4,
          color: TColor.white,
          shadowColor: isSettled ? TColor.secondary.withOpacity(0.3) : TColor.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSettled ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSettled ? TColor.secondary : TColor.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    isSettled ? 'Settled' : 'Unsettled',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TColor.placeholder.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            voucherId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dated,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: TColor.textfield,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmountColumn('Total', totalAmount, TColor.primary),
                          Container(height: 40, width: 1, color: Colors.grey[300]),
                          _buildAmountColumn('Settled', settledAmount, TColor.secondary),
                          Container(height: 40, width: 1, color: Colors.grey[300]),
                          _buildAmountColumn('Remaining', remainingAmount, TColor.fourth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountColumn(String label, String amount, Color amountColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
