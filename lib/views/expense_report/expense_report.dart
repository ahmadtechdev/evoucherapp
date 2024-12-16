import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';
import 'controller/expense_report_controller.dart';
import 'widgets/expense_widgets.dart';

class ExpenseComparisonReport extends StatelessWidget {
  ExpenseComparisonReport({super.key});

  final ExpenseReportController controller = Get.put(ExpenseReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Expenses Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 7),
      body: Column(
        children: [
          _buildDateSelectionHeader(),
          Expanded(
            child: Obx(() {
              final months = controller.getMonthsBetween();
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: months.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ExpenseWidgets.buildTotalSummaryCard(controller);
                  }
                  return ExpenseWidgets.buildMonthCard(
                    months[index - 1],
                    controller,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionHeader() {
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
            'From ${DateFormat('MMM yyyy').format(controller.fromDate.value)} '
                'To ${DateFormat('MMM yyyy').format(controller.toDate.value)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }
}