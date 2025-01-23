import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/round_text_field.dart';
import 'controller/top_supplier_sale_controller.dart';
import 'widgets/supplier_card.dart';

class SupplierReportScreen extends StatelessWidget {
  final SupplierReportController controller = Get.put(SupplierReportController());

  SupplierReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Top Customer Sale Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 15),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SearchTextField(
                hintText: "Search...",
                onChange: controller.updateSearch,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    children: [
                      ...controller.filteredActiveSupplier
                          .map((customer) => SupplierCard(supplier: customer)),
                      _buildZeroSalesHeader(),
                      ...controller.filteredZeroSaleSupplier
                          .map((customer) => SupplierCard(supplier: customer)),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: TColor.secondaryText.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: controller.selectedYear.value,
            underline: const SizedBox(),
            items: List.generate(5, (index) => 2024 - index).map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text('YEAR - $year'),
              );
            }).toList(),
            onChanged: (value) => controller.updateYear(value!),
          ),
        )),
        const SizedBox(width: 12),
        const Spacer(),
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: const Text('Print Report'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: TColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: controller.printReport,
        ),
      ],
    );
  }

  Widget _buildZeroSalesHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Accounts with Zero Sales',
        style: TextStyle(
          color: TColor.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}