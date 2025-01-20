
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/bottom_navigation.dart';
import 'bank/bank_entry_voucher.dart';
import 'bank/bank_view_voucher.dart';
import 'bank/unposted_b_voucher.dart';
import 'cash/cash_entry_voucher.dart';
import 'cash/cash_view_voucher.dart';
import 'cash/unposted_c_voucher.dart';
import 'expense/expense_entry_voucher.dart';
import 'expense/expense_view_voucher.dart';
import 'expense/unposted_e_voucher.dart';
import 'journal/journal_entry_voucher.dart';
import 'journal/journal_view_voucher.dart';
import 'journal/unposted_j_voucher.dart';

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
      drawer: const CustomDrawer(currentIndex: 0),
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
                  Get.to(() => const JournalEntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Journal Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.primary,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => const JournalViewVoucher());
                },
              ),
              VoucherOption(
                title: 'Unposted J Voucher',
                icon: Icons.pending_actions_outlined,
                color: TColor.primary,
                badge: '0',
                onTap: () {
                  // Handle Unposted J Voucher tap
                  Get.to(() => const UnPostedJVoucher());
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Cash Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Cash Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.secondary,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(() => const CashEntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Cash Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.secondary,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => const CashViewVoucher());
                },
              ),
              VoucherOption(
                title: 'Unposted C Voucher',
                icon: Icons.pending_actions_outlined,
                color: TColor.secondary,
                badge: '0',
                onTap: () {
                  // Handle Unposted J Voucher tap
                  Get.to(() => const UnPostedCVoucher());
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Expense Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Expense Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.fourth,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(() => const ExpenseEntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Expense Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.fourth,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => const ExpenseViewVoucher());
                },
              ),
              VoucherOption(
                title: 'Unposted E Voucher',
                icon: Icons.pending_actions_outlined,
                color: TColor.fourth,
                badge: '0',
                onTap: () {
                  // Handle Unposted J Voucher tap
                  Get.to(() => const UnPostedEVoucher());
                },
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Bank Voucher'),
            _buildVoucherOptions([
              VoucherOption(
                title: 'Entry Bank Voucher',
                icon: Icons.add_circle_outline,
                color: TColor.secondaryText,
                onTap: () {
                  // Handle Entry Journal Voucher tap
                  Get.to(() => const BankEntryVoucher());
                },
              ),
              VoucherOption(
                title: 'View Bank Voucher',
                icon: Icons.visibility_outlined,
                color: TColor.secondaryText,
                onTap: () {
                  // Handle View Journal Voucher tap
                  Get.to(() => const BankViewVoucher());
                },
              ),
              VoucherOption(
                title: 'Unposted B Voucher',
                icon: Icons.pending_actions_outlined,
                color: TColor.secondaryText,
                badge: '0',
                onTap: () {
                  // Handle Unposted J Voucher tap
                  Get.to(() => const UnpostedBVoucher());
                },
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 1,
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
