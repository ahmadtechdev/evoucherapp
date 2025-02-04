import 'package:evoucher_new/views/side_bar/manage_user/manage_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/color_extension.dart';
import '../../../../../common_widget/snackbar.dart';

class ManageUser extends StatelessWidget {
  final ManageUserController controller = Get.put(ManageUserController());

  ManageUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Customers List'),
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
              children: [],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: TColor.textField),
                  ),
                );
              }

              if (controller.ticketVouchers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 60,
                        color: TColor.secondaryText.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Records Found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColor.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No Record',
                        style: TextStyle(
                          fontSize: 14,
                          color: TColor.secondaryText.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.ticketVouchers.length,
                itemBuilder: (context, index) {
                  var ticket = controller.ticketVouchers[index];
                  return _buildVoucherCard(ticket, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Update the _buildVoucherCard method to handle the new data structure
  Widget _buildVoucherCard(Map<String, dynamic> ticket, BuildContext context) {
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
              color: ticket['needs_attention'] == true
                  ? Colors.red.withOpacity(0.1)
                  : TColor.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number,
                    color: ticket['needs_attention'] == true
                        ? Colors.red
                        : TColor.primary),
                const SizedBox(width: 10),
                Text(
                  ticket['VV_ID'],
                  style: TextStyle(
                    color: ticket['needs_attention'] == true
                        ? Colors.red
                        : TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  ticket['date'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility,
                      color: ticket['needs_attention'] == true
                          ? Colors.red
                          : TColor.primary),
                  onPressed: () {
                    // Get.to(() => const SingleVisaView());
                    CustomSnackBar(
                            message:
                                "This functionality is currently under development and will be available soon.",
                            backgroundColor: TColor.fourth)
                        .show();
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
                _buildInfoRow(Icons.calendar_today, 'Name', ticket['date']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person, 'Email', ticket['customer']),
                const SizedBox(height: 12),
                _buildInfoRow(
                    Icons.person_add, 'User Name', ticket['added_by']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.edit, 'Type', ticket['changes_by']),
                const SizedBox(height: 12),
                _buildInfoRow(
                    Icons.description, 'Status', ticket['description']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.business, 'Supplier Account',
                              ticket['supplier']),
                        ],
                      ),
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
                        'Invoice ',
                        Icons.receipt,
                        onPressed: () {
                          CustomSnackBar(
                                  message:
                                      "This functionality is currently under development and will be available soon.",
                                  backgroundColor: TColor.fourth)
                              .show();
                          // generateAndPreviewInvoice(
                          //     context,
                          //     ticket['VV_ID'].split(
                          //         ' ')[1]); // Extract ID number from "VV 841"
                        },
                      ),
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

  Widget _buildActionButton(String label, IconData icon,
      {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TColor.primary.withOpacity(0.05),
        foregroundColor: TColor.primary,
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
