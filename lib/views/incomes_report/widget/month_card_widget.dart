import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import 'income_card_widget.dart';
import '../controller/income_controller.dart';


class MonthCardWidget extends GetView<IncomesReportController> {
  final DateTime month;

  const MonthCardWidget({
    super.key,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.getMonthName(month.month)} ${month.year}',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.calendar_month, color: TColor.primary),
              ],
            ),
          ),
          IncomeCardWidget(
            title: 'Package Income',
            amount: '396,230.00',
            icon: Icons.receipt,
            color: TColor.primary,
          ),
          IncomeCardWidget(
            title: 'Ticket Income',
            amount: '72,698.00',
            icon: Icons.monetization_on,
            color: TColor.secondary,
          ),
          IncomeCardWidget(
            title: 'Hotel Incomes',
            amount: '241,671.00',
            icon: Icons.hotel,
            color: TColor.third,
          ),
          IncomeCardWidget(
            title: 'Visa Incomes',
            amount: '53,786.00',
            icon: Icons.credit_card,
            color: TColor.fourth,
          ),
          IncomeCardWidget(
            title: 'Other Incomes',
            amount: '0.00',
            icon: Icons.attach_money,
            color: TColor.primary,
          ),
          IncomeCardWidget(
            title: 'Transport Income',
            amount: '-22,210.00',
            icon: Icons.directions_car,
            color: TColor.secondary,
          ),
          IncomeCardWidget(
            title: 'Fine Penalties',
            amount: '0.00',
            icon: Icons.close,
            color: TColor.secondary,
          ),
          IncomeCardWidget(
            title: 'Other Penalties',
            amount: '-2.00',
            icon: Icons.devices_other,
            color: TColor.secondary,
          ),
          const Divider(thickness: 2, height: 1),
          IncomeCardWidget(
            title: 'Total',
            amount: '396,230.00',
            icon: Icons.summarize,
            color: TColor.primary,
            isLast: true,
          ),
        ],
      ),
    );
  }
}