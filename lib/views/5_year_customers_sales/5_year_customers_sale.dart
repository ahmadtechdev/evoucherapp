// lib/views/five_years_customer_sale.dart

import 'package:evoucher/views/5_year_customers_sales/widgets/top_search_dropdown_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import 'controller/5_years_customers_sales_controller.dart';

class FiveYearsCustomerSale extends StatelessWidget {
  const FiveYearsCustomerSale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FiveYearCustomersSalesController controller = Get.put(FiveYearCustomersSalesController());

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('5 Year Customer Sale Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 16),
      body: SafeArea(
        child: Column(
          children: [
            SearchDropdownWidget(controller: controller),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredData.length,
                  itemBuilder: (context, index) {
                    final sale = controller.filteredData[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text(sale.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(sale.total.toStringAsFixed(2)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: controller.years.map((year) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      year,
                                      style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      sale.yearlySales[year]
                                              ?.toStringAsFixed(2) ??
                                          "0.00",
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
