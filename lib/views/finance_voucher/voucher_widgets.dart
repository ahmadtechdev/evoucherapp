// voucher_widgets.dart

import 'package:evoucher/views/finance_voucher/expense/view_edit_e_voucher.dart';
import 'package:evoucher/views/finance_voucher/journal/view_unposted_vouchers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import 'cash/view_edit_c_voucher.dart';
import 'journal/view_edit_j_voucher.dart';

class EntryVoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;
  final String type;

  const EntryVoucherCard({
    super.key,
    required this.voucher,
    required this.type,
  });

  void _handleViewPress() {
    switch (type) {
      case 'journal':
        Get.to(() => JournalVoucherDetail(voucherData: voucher));
        break;
      case 'cash':
        Get.to(() => CashVoucherDetail(voucherData: voucher));
        break;
      case 'expense':
        Get.to(() => ExpenseVoucherDetail(voucherData: voucher));
      break;
      default:
        Get.to(() => JournalVoucherDetail(voucherData: voucher));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  voucher['id'],
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  voucher['date'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              voucher['description'],
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added by: ${voucher['addedBy']}',
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Entries: ${voucher['entries']}',
                      style: TextStyle(
                        color: TColor.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  voucher['amount'],
                  style: TextStyle(
                    color: TColor.fourth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  // onPressed: () {
                  //   Get.to(() => JournalVoucherDetail(voucherData: voucher));
                  // },
                  onPressed: _handleViewPress,
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColor.primary,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColor.secondary,
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

class EntryVoucherListView extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers;
  final String type;

  const EntryVoucherListView({
    super.key,
    required this.vouchers,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return EntryVoucherCard(voucher: vouchers[index], type: type,);
      },
    );
  }
}

class UnPostedVoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;

  const UnPostedVoucherCard({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher['id'],
                        style: TextStyle(
                          color: TColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      voucher['date'],
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                voucher['description'],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: TColor.fourth,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          voucher['addedBy'],
                          style: TextStyle(
                            color: TColor.fourth,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.format_list_numbered,
                          size: 16,
                          color: TColor.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${voucher['entries']} Entries',
                          style: TextStyle(
                            color: TColor.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // View Button
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(()=> const ViewUnPostedVouchers());
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: TColor.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

class UnPostedVoucherListView extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers;

  const UnPostedVoucherListView({
    super.key,
    required this.vouchers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return UnPostedVoucherCard(voucher: vouchers[index]);
      },
    );
  }
}
