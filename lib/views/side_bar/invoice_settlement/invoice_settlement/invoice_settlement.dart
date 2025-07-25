import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/accounts_dropdown.dart';
import '../../../../common/color_extension.dart';
import '../../../../common/drawer.dart';
import '../../../../common_widget/dart_selector2.dart';
import '../settle_invoice/single_invoice_settle.dart';
import 'controller/invoice_settlement_controller.dart';

class InvoiceSettlement extends StatelessWidget {
  const InvoiceSettlement({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceSettlementController controller =
        Get.put(InvoiceSettlementController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Invoice Settlement'),
      ),
      drawer: const CustomDrawer(currentIndex: 2),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          controller.fetchInvoices();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      TColor.primary),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading invoices...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: TColor.primaryText.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (controller.invoices.isEmpty) {
                        return Center(
                          child: Text(
                            'No Record In This Range',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: TColor.primaryText.withOpacity(0.6),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = controller.invoices[index];
                            return _buildInvoiceRow(
                              voucherId: invoice['voucher_id'],
                              dated: invoice['date'],
                              description: invoice['description'],
                              totalAmount: invoice['total_amount'],
                              settledAmount: invoice['settled_amount'],
                              remainingAmount: invoice['remaining_amount'],
                              status: invoice['status'],
                            );
                          },
                        );
                      }
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeSection(InvoiceSettlementController controller) {
    return Container(
      color: TColor.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: DateSelector2(
              fontSize: 14,
              initialDate: controller.dateFrom.value,
              onDateChanged: (date) {
                controller.setDateRange(date, controller.dateTo.value);
                controller.fetchInvoices();
              },
              label: "FROM: ",
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: DateSelector2(
              fontSize: 14,
              initialDate: controller.dateTo.value,
              onDateChanged: (date) {
                controller.setDateRange(controller.dateFrom.value, date);
                controller.fetchInvoices();
              },
              label: "TO:  ",
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow({
    required String voucherId,
    required String dated,
    required String description,
    required String totalAmount,
    required String settledAmount,
    required String remainingAmount,
    required String status, // Added status parameter
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: GestureDetector(
        onTap: status != 'settled'
            ? () {
                Get.to(() => const SingleInvoiceSettlementPage());
              }
            : null, // Disable tap if status is "settled"
        child: Card(
          elevation: 4,
          color: TColor.white,
          shadowColor: status == 'settled'
              ? TColor.secondary.withOpacity(0.3)
              : TColor.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: status == 'settled'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        status == 'settled' ? TColor.secondary : TColor.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    status == 'settled' ? 'Settled' : 'Unsettled',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
                        Expanded(
                          child: Text(
                            dated,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                            ),
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
                        color: TColor.textField,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmountColumn(
                              'Total', totalAmount.toString(), TColor.primary),
                          Container(
                              height: 40, width: 1, color: Colors.grey[300]),
                          _buildAmountColumn('Settled',
                              settledAmount.toString(), TColor.secondary),
                          Container(
                              height: 40, width: 1, color: Colors.grey[300]),
                          _buildAmountColumn('Remaining',
                              remainingAmount.toString(), TColor.fourth),
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

  Widget _buildAmountColumn(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.primaryText.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
