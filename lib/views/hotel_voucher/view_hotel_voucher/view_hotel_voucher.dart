import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'foriiegn_invoice/hotel_view_voucher_detail.dart';
import 'hotel_invoices_view/view/single_hotel_view.dart';
import 'invoices_functions_class.dart';
import 'view_hotel_voucher_controller.dart';


class ViewHotelVoucher extends StatelessWidget {
  final HotelVoucherController controller = Get.put(HotelVoucherController());

  // Create an instance of the InvoiceGenerator class
  final invoiceGenerator = InvoiceGenerator();
  ViewHotelVoucher({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Hotel Vouchers'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DateSelector2(
                        label: 'From Date',
                        fontSize: 14,
                        initialDate: DateTime.now(),
                        onDateChanged: (DateTime value) {},
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DateSelector2(
                        label: 'To Date',
                        fontSize: 14,
                        initialDate: DateTime.now(),
                        onDateChanged: (DateTime value) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.ticketVouchers.length,
                  itemBuilder: (context, index) {
                    var ticket = controller.ticketVouchers[index];
                    return _buildVoucherCard(ticket, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, String> ticket, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number, color: TColor.primary),
                const SizedBox(width: 10),
                Text(
                  'HV ID: ${ticket['hv_id']}',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.visibility, color: TColor.primary),
                  onPressed: () {
                    // Implement view action
                    Get.to(()=> const SingleHotelView());
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    Icons.person, 'Customer', ticket['customer'] ?? ''),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.description, 'Description',
                    ticket['description'] ?? ''),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.business, 'Supplier Account',
                    ticket['supplier'] ?? ''),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(Icons.person_add, 'Added by',
                          ticket['added_by'] ?? ''),
                    ),
                    Text(
                      'PKR ${ticket['price']}',
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                          'New Invoice', Icons.receipt, TColor.secondary, onPressed: () {
                        // generateAndPreviewNewHotelInvoice(context);
                        invoiceGenerator.generateAndPreviewNewHotelInvoice(context);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                          'Hotel Invoice', Icons.receipt_long, TColor.black, onPressed: () {
                        invoiceGenerator.generateAndPreviewDefiniteHotelInvoice(context);
    }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                          'Hotel Voucher', Icons.visibility, TColor.primary,  onPressed: (){
                            invoiceGenerator.generateAndPreviewHotelVoucher(context);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                          'Foreign Invoice', Icons.visibility, Colors.red,  onPressed: (){
                            invoiceGenerator.generateAndPreviewForeignInvoice(context);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: TColor.secondaryText),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color backgroundColor, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor.withOpacity(0.7),
        foregroundColor: TColor.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

}
