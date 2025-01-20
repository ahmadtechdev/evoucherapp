import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/total_monthly_profit_loss_controller.dart';
import 'models/total_monthly_profit_loss_model.dart';


class TotalMonthlyProfitLoss extends StatelessWidget {
  TotalMonthlyProfitLoss({super.key});

  final TotalMonthlyProfitLossController controller = Get.put(TotalMonthlyProfitLossController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Total Monthly Profit Loss'),
      ),
      drawer: const CustomDrawer(currentIndex: 13),
      body: Column(
        children: [
          _buildDateSelectionHeader(),
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...controller.companies.map((company) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCompanyHeader(company.name),
                      ...controller.getMonthsBetween().map((month) =>
                          _buildMonthCard(company, month)),
                      const SizedBox(height: 24),
                    ],
                  )),
                  _buildTotalSection(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _buildDateSelectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() => DateSelector2(
                  label: 'From Month',
                  fontSize: 12,
                  initialDate: controller.fromDate.value,
                  selectMonthOnly: true,
                  onDateChanged: controller.updateFromDate,
                )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => DateSelector2(
                  label: 'To Month',
                  fontSize: 12,
                  initialDate: controller.toDate.value,
                  selectMonthOnly: true,
                  onDateChanged: controller.updateToDate,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildDataRow(String label, Map<String, double> data, {bool isProfitLoss = false}) {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 100,
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             color: TColor.primaryText,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: controller.getMonthsBetween().map((month) {
  //             final value = data[controller.getMonthKey(month)] ?? 0.0;
  //             return Text(
  //               value.toStringAsFixed(2),
  //               style: TextStyle(
  //                 color: isProfitLoss
  //                     ? controller.getColorForProfitLoss(value)
  //                     : TColor.primaryText,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCompanyHeader(String companyName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        companyName,
        style: TextStyle(
          color: TColor.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMonthCard(TotalMonthlyProfitLossModel company, DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final expenses = company.expenses[monthKey] ?? 0.0;
    final incomes = company.incomes[monthKey] ?? 0.0;
    final profitLoss = company.profitLoss[monthKey] ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(month),
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.calendar_month, color: TColor.primary, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildMonthDataRow('Expenses', expenses),
                _buildMonthDataRow('Incomes', incomes),
                const Divider(height: 16),
                _buildMonthDataRow(
                  'Profit/Loss',
                  profitLoss,
                  color: controller.getColorForProfitLoss(profitLoss),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthDataRow(String label, double value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: color ?? TColor.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColor.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'TOTAL',
            style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...controller.getMonthsBetween().map((month) =>
            _buildTotalMonthCard(month)),
        const SizedBox(height: 16),
        _buildFinalTotal(),
      ],
    );
  }

  Widget _buildTotalMonthCard(DateTime month) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(month),
              style: TextStyle(
                color: TColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...controller.companies.map((company) =>
                _buildCompanyTotalRow(company, month)),
            const Divider(height: 24),
            _buildMonthTotalRow(month),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyTotalRow(TotalMonthlyProfitLossModel company, DateTime month) {
    final monthKey = controller.getMonthKey(month);
    final profitLoss = company.profitLoss[monthKey] ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            company.name,
            style: TextStyle(color: TColor.primaryText),
          ),
          Text(
            profitLoss.toStringAsFixed(2),
            style: TextStyle(
              color: controller.getColorForProfitLoss(profitLoss),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthTotalRow(DateTime month) {
    final total = controller.calculateMonthTotal(month);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          total.toStringAsFixed(2),
          style: TextStyle(
            color: controller.getColorForProfitLoss(total),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalTotal() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Final Total',
              style: TextStyle(
                color: TColor.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.companies.map((company) =>
                _buildCompanyFinalRow(company)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total',
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.calculateTotalProfit().toStringAsFixed(2),
                  style: TextStyle(
                    color: controller.getColorForProfitLoss(
                      controller.calculateTotalProfit(),
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyFinalRow(TotalMonthlyProfitLossModel company) {
    final total = company.getTotalProfit();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            company.name,
            style: TextStyle(color: TColor.primaryText),
          ),
          Text(
            total.toStringAsFixed(2),
            style: TextStyle(
              color: controller.getColorForProfitLoss(total),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}