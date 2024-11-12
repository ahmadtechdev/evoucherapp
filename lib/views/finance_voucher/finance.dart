import 'package:evoucher/views/finance_voucher/journal_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common_widget/bottom_navigation.dart';

class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finance Vouchers',
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColor.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Journal Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Journal Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.primary,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(()=>JournalVoucher());
                },
              ),
              VoucherOption(
                title: 'View Journal Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.primary,
                onTap: () {
                  // Handle View Journal Voucher tap
                },
              ),
              VoucherOption(
                title: 'Unposted J Voucher',
                icon: Icons.pending_actions_outlined,
                color: TColor.primary,
                badge: '0',
                onTap: () {
                  // Handle Unposted J Voucher tap
                },
              ),
              VoucherOption(
                title: 'Void Journal Voucher',
                icon: Icons.block_outlined,
                color: TColor.primary,
                onTap: () {
                  // Handle Void Journal Voucher tap
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Foreign Payment Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Foreign Payment',
                icon: Icons.add_circle_outline,
                color: TColor.secondary,
                onTap: () {
                  // Handle Entry Foreign Payment tap
                },
              ),
              VoucherOption(
                title: 'View Foreign Payment',
                icon: Icons.visibility_outlined,
                color: TColor.secondary,
                onTap: () {
                  // Handle View Foreign Payment tap
                },
              ),
              VoucherOption(
                title: 'Voided Foreign Payment',
                icon: Icons.block_outlined,
                color: TColor.secondary,
                onTap: () {
                  // Handle Voided Foreign Payment tap
                },
              ),
              VoucherOption(
                title: 'Foreign Payment Report',
                icon: Icons.description_outlined,
                color: TColor.secondary,
                onTap: () {
                  // Handle Foreign Payment Report tap
                },
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0,),
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
                : Icon(
              Icons.chevron_right,
              color: TColor.secondaryText,
            ),
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