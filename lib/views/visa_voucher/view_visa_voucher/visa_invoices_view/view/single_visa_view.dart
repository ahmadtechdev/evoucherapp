
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/color_extension.dart';
import 'single_visa_view_controller.dart';

class SingleVisaView extends StatefulWidget {
  const SingleVisaView({super.key});

  @override
  State<SingleVisaView> createState() => _SingleVisaViewState();
}

class _SingleVisaViewState extends State<SingleVisaView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SingleVisaViewController controller = Get.put(SingleVisaViewController());

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
        title: const Text('View Visa Voucher',
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                      'Edit', Icons.edit, TColor.secondary, context,
                      onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton('Invioce',
                      Icons.insert_page_break_rounded, TColor.third, context,
                      onPressed: () {}),
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
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: 'Customer Information',
              content: [
                _buildInfoRow('Customer Account',
                    controller.customerData['Customer Account']),
                _buildInfoRow(
                    'Customer Name', controller.customerData['Customer Name']),
                _buildInfoRow(
                    'Passport No', controller.customerData['Passport No']),
                _buildInfoRow('Visa No', controller.customerData['Visa No']),
                _buildInfoRow('V. Type', controller.customerData['V. Type']),
                _buildInfoRow('Country', controller.customerData['Country']),
                _buildInfoRow('Phone No', controller.customerData['Phone No']),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Financial Details',
              content: [
                _buildInfoRow('Foreign Sale Rate',
                    controller.customerData['Foreign Sale Rate']),
                _buildInfoRow('Rate of Exchange',
                    controller.customerData['Rate of Exchange']),
                _buildInfoRow('PKR Total Selling',
                    controller.customerData['PKR Total Selling']),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Already Receivings',
              content: List.generate(controller.receivingData.length, (index) {
                final item = controller.receivingData[index];
                return Text(
                  '${index + 1}) ${item['id']} (Amount: ${item['amount']})',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSupplierDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: 'Supplier Information',
              content: [
                _buildInfoRow('Supplier Account',
                    controller.supplierData['Supplier Account']),
                _buildInfoRow('Consultant Name',
                    controller.supplierData['Consultant Name']),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Financial Details',
              content: [
                _buildInfoRow('Foreign Purchase Rate',
                    controller.supplierData['Foreign Purchase Rate']),
                _buildInfoRow('Rate of Exchange',
                    controller.supplierData['Rate of Exchange']),
                _buildInfoRow('Currency', controller.supplierData['Currency']),
                _buildInfoRow('PKR Total Buying',
                    controller.supplierData['PKR Total Buying']),
                _buildInfoRow('Profit', controller.supplierData['Profit']),
                _buildInfoRow('Loss', controller.supplierData['Loss']),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Remarks and Status',
              content: [
                _buildInfoRow('Status', controller.supplierData['Status']),
                _buildInfoRow('Remarks', controller.supplierData['Remarks']),
                _buildInfoRow(
                    'Total Debit', controller.supplierData['Total Debit']),
                _buildInfoRow(
                    'Total Credit', controller.supplierData['Total Debit']),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
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
