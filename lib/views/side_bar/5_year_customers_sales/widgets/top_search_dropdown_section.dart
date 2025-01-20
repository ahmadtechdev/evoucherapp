// lib/widgets/search_dropdown_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/round_text_field.dart';
import '../controller/five_years_customers_sales_controller.dart';

class SearchDropdownWidget extends StatelessWidget {
  final FiveYearCustomersSalesController controller;

  const SearchDropdownWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: SearchTextField(
              hintText: 'Search accounts...',
              onChange: (value) => controller.searchQuery.value = value,
            ),
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: TColor.textField,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedYear.value,
                hint: const Text("Select Year"),
                items: controller.years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedYear.value = value;
                  controller.fetchFiveYearSales();
                },
              ),
            ),
          )),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}