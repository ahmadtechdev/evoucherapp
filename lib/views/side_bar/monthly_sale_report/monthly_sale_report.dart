// monthly_sales_report_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/dart_selector2.dart';
import 'widgets/monthly_sale_card.dart';
import 'controller/monthly_sale_controller.dart';
import 'widgets/sales_summary_card.dart';


class MonthlySalesReport extends StatelessWidget {
  MonthlySalesReport({super.key});

  final MonthlySalesController controller = Get.put(MonthlySalesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Monthly Sales Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 6),
      body: Column(
        children: [
          _buildDateFilterSection(),
          Expanded(
            child: _buildSalesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterSection() {
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
          _buildDateSelectors(),
          const SizedBox(height: 16),
          Obx(() => Text(
            'From ${controller.formatDate(controller.fromDate.value)} '
                'To ${controller.formatDate(controller.toDate.value)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      children: [
        Expanded(
          child: DateSelector2(
            label: 'From Month',
            fontSize: 12,
            initialDate: controller.fromDate.value,
            selectMonthOnly: true,
            onDateChanged: controller.updateFromDate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DateSelector2(
            label: 'To Month',
            fontSize: 12,
            initialDate: controller.toDate.value,
            selectMonthOnly: true,
            onDateChanged: controller.updateToDate,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesList() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.months.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SalesSummaryCard();
        }
        return MonthlySalesCard(
          month: controller.months[index - 1],
          controller: controller,
        );
      },
    ));
  }
}