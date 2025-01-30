import 'package:evoucher_new/views/bottom_bar/other_vouchers/invoice_voucher/view_invoice_voucher/view_invoice_voucher.dart';
import 'package:evoucher_new/views/bottom_bar/other_vouchers/other_voucher/other_entry_voucher/other_entry_voucher.dart';
import 'package:evoucher_new/views/bottom_bar/other_vouchers/other_voucher/view_other_voucher/view_other_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/bottom_navigation.dart';
import 'transport_voucher/transport_entry_voucher/transport_entry_voucher.dart';
import 'transport_voucher/view_transport_voucher/view_transport_voucher.dart';

class Other_voucher extends StatefulWidget {
  const Other_voucher({super.key});

  @override
  State<Other_voucher> createState() => _Other_voucherState();
}

class _Other_voucherState extends State<Other_voucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Other Vouchers',
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColor.white,
        elevation: 1,
      ),
      drawer: const CustomDrawer(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Other Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Other Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.primary,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(() => const OtherEntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Other Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.primary,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => ViewOtherVoucher());
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Invoice  Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Invoice  Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.secondary,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  // Get.to(() => const Invoice EntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Invoice  Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.secondary,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => ViewInvoiceVoucher());
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Transport  Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Transport  Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.fourth,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(() => TransportEntryVoucherScreen());
                },
              ),
              VoucherOption(
                title: 'View Transport Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.fourth,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => ViewTransportVoucher());
                },
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 5,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVoucherOptions(List<VoucherOption> options) {
    return Column(
      children: options.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              option.icon,
              color: option.color,
              size: 24,
            ),
            title: Text(
              option.title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
              ),
            ),
            trailing: option.badge != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: TColor.third,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      option.badge!,
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                : null,
            // Icon(
            //   Icons.chevron_right,
            //   color: TColor.secondaryText,
            // ),
            onTap: option.onTap,
          ),
        );
      }).toList(),
    );
  }
}

class VoucherOption {
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  VoucherOption({
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });
}
