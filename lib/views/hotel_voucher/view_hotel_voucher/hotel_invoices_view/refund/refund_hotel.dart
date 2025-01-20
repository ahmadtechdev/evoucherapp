import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/color_extension.dart';
import '../../../../../common_widget/dart_selector2.dart';
import 'refund_hotel_controller.dart';

class RefundHotelView extends StatefulWidget {
  const RefundHotelView({super.key});

  @override
  State<RefundHotelView> createState() => _RefundHotelViewState();
}

class _RefundHotelViewState extends State<RefundHotelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefundHotelController controller = Get.put(RefundHotelController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title: const Text('Refund Hotel Voucher',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: TColor.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Customer Details'),
                Tab(text: 'Supplier Details'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DateSelector2(
                    label: 'Date',
                    fontSize: 14,
                    initialDate: DateTime.now(),
                    onDateChanged: (DateTime value) {},
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: DateSelector2(
                    label: 'Cancellation',
                    fontSize: 14,
                    initialDate: DateTime.now(),
                    onDateChanged: (DateTime value) {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerRefundTab(),
                _buildSupplierRefundTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRefundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
            children: [
              _buildInfoCard(
                'Customer Information',
                [
                  _buildInfoRow('Customer Account',
                      controller.customerRefundData['Customer Account']!),
                  _buildInfoRow(
                      'PAX Name', controller.customerRefundData['PAX Name']!),
                  _buildInfoRow('Hotel Name',
                      controller.customerRefundData['Hotel Name']!),
                  _buildInfoRow(
                      'Country', controller.customerRefundData['Country']!),
                  _buildInfoRow('City', controller.customerRefundData['City']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                'Stay Details',
                [
                  _buildInfoRow(
                      'Check In', controller.customerRefundData['Check In']!),
                  _buildInfoRow(
                      'Check Out', controller.customerRefundData['Check Out']!),
                  _buildInfoRow(
                      'Nights', controller.customerRefundData['Nights']!),
                  _buildInfoRow(
                      'Room Type', controller.customerRefundData['Room Type']!),
                  _buildInfoRow('Meal', controller.customerRefundData['Meal']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                'Refund Details',
                [
                  _buildInfoRow(
                      'Refund to Per Night Sale',
                      controller
                          .customerRefundData['Refund to Per Night Sale']!),
                  _buildInfoRow(
                      'Refund to Total Sale Amount',
                      controller
                          .customerRefundData['Refund to Total Sale Amount']!),
                  _buildInfoRow(
                      'Refund to Rate of Exchange',
                      controller
                          .customerRefundData['Refund to Rate of Exchange']!),
                  _buildInfoRow(
                      'Currency', controller.customerRefundData['Currency']!),
                  _buildInfoRow(
                      'Refund to PKR Total Selling',
                      controller
                          .customerRefundData['Refund to PKR Total Selling']!),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildSupplierRefundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
            children: [
              _buildInfoCard(
                'Supplier Information',
                [
                  _buildInfoRow('Supplier Account',
                      controller.supplierRefundData['Supplier Account']!),
                  _buildInfoRow(
                      'Supplier Confirmation Number',
                      controller
                          .supplierRefundData['Supplier Confirmation Number']!),
                  _buildInfoRow(
                      'Hotel Confirmation Number',
                      controller
                          .supplierRefundData['Hotel Confirmation Number']!),
                  _buildInfoRow('Consultant Name',
                      controller.supplierRefundData['Consultant Name']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                'Refund Details',
                [
                  _buildInfoRow(
                      'Refund from Per Night Buying',
                      controller
                          .supplierRefundData['Refund from Per Night Buying']!),
                  _buildInfoRow(
                      'Refund from Total Buying Amount',
                      controller.supplierRefundData[
                          'Refund from Total Buying Amount']!),
                  _buildInfoRow(
                      'Refund from Rate of Exchange',
                      controller
                          .supplierRefundData['Refund from Rate of Exchange']!),
                  _buildInfoRow(
                      'Currency', controller.supplierRefundData['Currency']!),
                  _buildInfoRow(
                      'Refund from PKR Total Buying',
                      controller
                          .supplierRefundData['Refund from PKR Total Buying']!),
                  _buildInfoRow('Voucher Profit',
                      controller.supplierRefundData['Voucher Profit']!),
                  _buildInfoRow('Voucher Loss',
                      controller.supplierRefundData['Voucher Loss']!),
                  _buildInfoRow('Now Profit',
                      controller.supplierRefundData['Now Profit']!),
                  _buildInfoRow(
                      'Now Loss', controller.supplierRefundData['Now Loss']!),
                ],
              ),
              const SizedBox(height: 10),
              _buildRemarksSection(),
              const SizedBox(height: 10),
            ],
          )),
    );
  }

  Widget _buildRemarksSection() {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Remarks',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: controller.updateRemarks,
    );
  }

  Widget _buildInfoCard(String title, List<Widget> content) {
    return Card(
      color: TColor.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
