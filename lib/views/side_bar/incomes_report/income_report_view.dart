import 'package:evoucher/views/side_bar/incomes_report/widget/month_card_widget.dart';
import 'package:evoucher/views/side_bar/incomes_report/widget/total_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'controller/income_controller.dart';


class IncomesComparisonReport extends GetView<IncomesReportController> {
  const IncomesComparisonReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Incomes Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 8),
      body: Column(
        children: [
          _buildDateSelectors(),
          Expanded(
            child: Obx(() {
              final months = controller.getMonthsBetween();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: months.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildTotalSummaryCard();
                  }
                  return MonthCardWidget(month: months[index - 1]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.getFormattedDateRange(),
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTotalSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.primary.withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Incomes Summary',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TotalItemWidget(
                  label: 'Package Income',
                  amount: '396,230.00',
                  icon: Icons.receipt,
                ),
              ),
              Expanded(
                child: TotalItemWidget(
                  label: 'Ticket Income',
                  amount: '72,698.00',
                  icon: Icons.monetization_on,
                ),
              ),
              Expanded(
                child: TotalItemWidget(
                  label: 'Hotel Incomes',
                  amount: '241,671.00',
                  icon: Icons.hotel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: TotalItemWidget(
                  label: 'Visa Incomes',
                  amount: '53,786.00',
                  icon: Icons.credit_card,
                ),
              ),
              Expanded(
                child: TotalItemWidget(
                  label: 'Other Incomes',
                  amount: '2,793.00',
                  icon: Icons.attach_money,
                ),
              ),
              Expanded(
                child: TotalItemWidget(
                  label: 'Transport Income',
                  amount: '22,210.00',
                  icon: Icons.directions_car,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: TotalItemWidget(
                  label: 'Fine Penalties',
                  amount: '53,786.00',
                  icon: Icons.close,
                ),
              ),
              Expanded(
                child: TotalItemWidget(
                  label: 'Other Penalties',
                  amount: '2,793.00',
                  icon: Icons.devices_other,
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}