import 'package:evoucher/common_widget/dart_selector2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evoucher/common/color_extension.dart';

import '../refund/refund_hotel.dart';
import 'hotel_view_controller.dart';

class SingleHotelView extends StatefulWidget {
  const SingleHotelView({super.key});

  @override
  State<SingleHotelView> createState() => _SingleHotelViewState();
}

class _SingleHotelViewState extends State<SingleHotelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SingleHotelViewController controller = Get.put(SingleHotelViewController());

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
        title: const Text('View Hotel Voucher',
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
                _buildCustomerDetailsTab(),
                _buildSupplierDetailsTab(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                      'Edit', Icons.edit, TColor.secondary, context,
                      onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                      'Refund', Icons.currency_exchange, TColor.third, context,
                      onPressed: () {
                    Get.to(RefundHotelView());
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                      'Delete', Icons.delete, TColor.fourth, context,
                      onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Customer Information',
                content: [
                  _buildInfoRow('Customer Account',
                      controller.customerData['Customer Account']!),
                  _buildInfoRow(
                      'PAX Name', controller.customerData['PAX Name']!),
                  _buildInfoRow(
                      'Hotel Name', controller.customerData['Hotel Name']!),
                  _buildInfoRow('Country', controller.customerData['Country']!),
                  _buildInfoRow('City', controller.customerData['City']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Booking Details',
                content: [
                  _buildInfoRow(
                      'Check In', controller.customerData['Check In']!),
                  _buildInfoRow(
                      'Check Out', controller.customerData['Check Out']!),
                  _buildInfoRow('Nights', controller.customerData['Nights']!),
                  _buildInfoRow(
                      'Room Type', controller.customerData['Room Type']!),
                  _buildInfoRow('Meal', controller.customerData['Meal']!),
                  _buildInfoRow(
                      'Rooms/Beds', controller.customerData['Rooms/Beds']!),
                  _buildInfoRow('No. of Adults',
                      controller.customerData['No. of Adults']!),
                  _buildInfoRow(
                      'No. of Child', controller.customerData['No. of Child']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Payment Details',
                content: [
                  _buildInfoRow('Per Night Sale',
                      controller.customerData['Per Night Sale']!),
                  _buildInfoRow('Total Sale Amount',
                      controller.customerData['Total Sale Amount']!),
                  _buildInfoRow('Rate of Exchange',
                      controller.customerData['Rate of Exchange']!),
                  _buildInfoRow(
                      'Currency', controller.customerData['Currency']!),
                  _buildInfoRow('PKR Total Selling',
                      controller.customerData['PKR Total Selling']!),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildSupplierDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Supplier Information',
                content: [
                  _buildInfoRow('Supplier Account',
                      controller.supplierData['Supplier Account']!),
                  _buildInfoRow('Supplier Confirmation Number',
                      controller.supplierData['Supplier Confirmation Number']!),
                  _buildInfoRow('Hotel Confirmation Number',
                      controller.supplierData['Hotel Confirmation Number']!),
                  _buildInfoRow('Consultant Name',
                      controller.supplierData['Consultant Name']!),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Financial Details',
                content: [
                  _buildInfoRow('Per Night Buying',
                      controller.supplierData['Per Night Buying']!),
                  _buildInfoRow('Total Buying Amount',
                      controller.supplierData['Total Buying Amount']!),
                  _buildInfoRow('Rate of Exchange',
                      controller.supplierData['Rate of Exchange']!),
                  _buildInfoRow(
                      'Currency', controller.supplierData['Currency']!),
                  _buildInfoRow('PKR Total Buying',
                      controller.supplierData['PKR Total Buying']!),
                  _buildInfoRow('Profit', controller.supplierData['Profit']!),
                  _buildInfoRow('Loss', controller.supplierData['Loss']!),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color backgroundColor, BuildContext context,
      {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: TColor.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoCard({required String title, required List<Widget> content}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              color: TColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: content),
        ),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDateField(String label, String value) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: TColor.textField,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
