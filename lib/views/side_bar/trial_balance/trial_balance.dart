import 'package:evoucher/common_widget/date_selecter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../charts_of_accounts/widgets/accounts_header_card.dart';
import 'controller/trial_of_balance_controller.dart';

class TrialOfBalanceScreen extends StatelessWidget {
  final TrialOfBalanceController controller =
      Get.put(TrialOfBalanceController());

  TrialOfBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text(
          'Trial Balance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      drawer: const CustomDrawer(
        currentIndex: 11,
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
                    controller.selectedDate.value = newDate;
                    controller.fetchTrialBalance();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.accountHeaders.length,
                      itemBuilder: (context, index) {
                        final header = controller.accountHeaders[index];
                        return AccountHeaderCard(header: header);
                      },
                    ),
                  ),
                  _buildSummaryCard(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalDebit = controller.totalDebit;
    final totalCredit = controller.totalCredit;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Total Debit',
              totalDebit.toStringAsFixed(2),
              Icons.arrow_upward,
              TColor.third,
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey[300],
            ),
            _buildSummaryItem(
              'Total Credit',
              totalCredit.toStringAsFixed(2),
              Icons.arrow_downward,
              TColor.fourth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String amount, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
