import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../charts_of_accounts/widgets/accounts_header_card.dart';
import 'controller/trial_of_balance_controller.dart';


class TrialOfBalanceScreen extends StatelessWidget {
  final TrialOfBalanceController controller = Get.put(TrialOfBalanceController());

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
      drawer: const CustomDrawer(currentIndex: 11,),
      body: Obx(() {
        return Column(
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
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: TColor.primary.withOpacity(0.1),
            //     border: Border(
            //       top: BorderSide(color: TColor.primary.withOpacity(0.2)),
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       _buildSummaryItem('Total Debit', controller.totalDebit),
            //       _buildSummaryItem('Total Credit', controller.totalCredit),
            //     ],
            //   ),
            // ),
          ],
        );
      }),
    );
  }
  Widget _buildSummaryCard() {
    final totalDebit = controller.getDummyData()
        .fold(0.0, (sum, header) => sum + header.totalDebit);
    final totalCredit = controller.getDummyData()
        .fold(0.0, (sum, header) => sum + header.totalCredit);

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