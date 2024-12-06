import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_textfield.dart';
import 'controller/settle_invoice_controller.dart';

class SingleInvoiceSettlementPage extends StatelessWidget {
  const SingleInvoiceSettlementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettleInvoiceController controller = Get.put(SettleInvoiceController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
          title: const Text('Invoice Settlement'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildPaymentDetailsCard(),
                      _buildUnsettledInvoicesHeader(),
                      ...controller.invoices.map((invoice) {
                        return _buildUnsettledInvoiceCard(controller, invoice);
                      }).toList(),
                      SizedBox(height: controller.selectedInvoices.isEmpty ? 0 : 300),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.selectedInvoices.isNotEmpty) {
                return _buildSelectedInvoicesSheet(controller);
              } else {
                return SizedBox.shrink(); // Return an empty widget if no invoices are selected
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Selected Payment Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CV-329",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  "04 Aug 2023",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Cash received from AFAQ Travel",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "50,000.00 PKR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsettledInvoicesHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "All Un-Settled Invoices",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: TColor.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildUnsettledInvoiceCard(SettleInvoiceController controller, Map<String, dynamic> invoice) {
    return Obx(() { // Make the card reactive
      bool isSelected = controller.selectedInvoices.contains(invoice);
      return GestureDetector(
        onTap: () {
          controller.toggleInvoiceSelection(invoice);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: isSelected ? 6 : 4,
          shadowColor: isSelected ? TColor.secondary : TColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? TColor.secondary : TColor.primary,
              width: isSelected ? 2 : 1,
            ),
          ),
          color: isSelected ? TColor.secondary.withOpacity(0.9) : TColor.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoice['id'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? TColor.white : TColor.primaryText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? TColor.white.withOpacity(0.8) : TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${invoice['remainingAmount']} PKR",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? TColor.secondary : TColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Date: ${invoice['date']}",
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? TColor.white.withOpacity(0.8) : TColor.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  invoice['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? TColor.white : TColor.primaryText.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSelectedInvoicesSheet(SettleInvoiceController controller) {
    print(controller.selectedInvoices);
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: TColor.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TColor.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Selected Invoices to be Settled",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.secondary,
                          ),
                        ),
                      ),
                    ),
                    ...controller.selectedInvoices.map((invoice) {
                      return _buildSelectedInvoiceCard(controller, invoice);
                    }).toList(),
                  ],
                ),
              ),
              _buildTotalPaymentSection(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedInvoiceCard(SettleInvoiceController controller, Map<String, dynamic> invoice) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shadowColor: TColor.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: TColor.secondary,
          width: 1,
        ),
      ),
      color: TColor.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice['id'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TColor.primaryText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TColor.third.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${invoice['remainingAmount']} PKR",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: TColor.third,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              invoice['description'],
              style: TextStyle(
                fontSize: 14,
                color: TColor.primaryText.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Settle Amount: "),
                Expanded(
                  child: RoundTextfield(
                    hintText: "Enter amount",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.setSettledAmount(invoice, value);
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

  Widget _buildTotalPaymentSection(SettleInvoiceController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: TColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Payment: ${controller.totalPayment}",
                    style: TextStyle(fontSize: 16, color: TColor.third),
                  ),
                  Text(
                    "Difference: ${controller.difference}",
                    style: TextStyle(fontSize: 16, color: TColor.primary),
                  ),
                  Text(
                    "Payment to Settle: ${controller.totalSettled}",
                    style: TextStyle(fontSize: 16, color: TColor.secondary),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle settlement logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.secondary,
                  foregroundColor: TColor.white,
                ),
                child: const Text("Settle Now"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}