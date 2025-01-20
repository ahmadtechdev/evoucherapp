import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/color_extension.dart';
import 'refund_ticket_controler.dart';

class TicketRefundTicketScreen extends StatefulWidget {
  const TicketRefundTicketScreen({super.key});

  @override
  State<TicketRefundTicketScreen> createState() => _TicketRefundTicketScreenState();
}

class _TicketRefundTicketScreenState extends State<TicketRefundTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefundTicketController controller = Get.put(RefundTicketController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title:
            const Text('Refund Ticket', style: TextStyle(color: Colors.white)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateField('Date:', '26 Dec 2024'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField('Issue Date:', '24 Dec 2024'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildcustomerDataDetailsTab(),
                _buildsupplierDataDetailsTab(),
              ],
            ),
          ),
          _buildTotalSection(),
        ],
      ),
    );
  }

  Widget _buildcustomerDataDetailsTab() {
    return Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Basic Information',
                content: [
                  for (var entry in {
                    'customerData Account':
                        controller.customerData['Customer Account'],
                    'PAX Name': controller.customerData['PAX Name'],
                    'PNR': controller.customerData['PNR'],
                    'Ticket Number': controller.customerData['Ticket Number'],
                    'Airline': controller.customerData['Airline'],
                    'Sector': controller.customerData['Sector'],
                    'Segments': controller.customerData['Segments'],
                    'Sector Type': controller.customerData['Sector Type'],
                  }.entries)
                    _buildInfoRow(entry.key, entry.value ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Taxes & Charges',
                content: [
                  _buildInfoRow('Basic Fare',
                      controller.customerData['Basic Fare'] ?? ''),
                  _buildInfoRow('Other Taxes',
                      controller.customerData['Other Taxes'] ?? ''),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      for (var tax in [
                        'EMD',
                        'CC',
                        'SP',
                        'RG',
                        'YD',
                        'E3',
                        'IO',
                        'YI',
                        'XZ',
                        'PK',
                        'ZR',
                        'YQ'
                      ])
                        _buildTaxBox(tax, controller.customerData[tax] ?? '0'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Charges & Commission',
                content: [
                  _buildInfoRow('Basic Fare CHGS %',
                      controller.customerData['Basic Fare CHGS %'] ?? ''),
                  _buildInfoRow('Basic Fare CHGS PKR',
                      controller.customerData['Basic Fare CHGS PKR'] ?? ''),
                  _buildInfoRow(
                      'Total Fare CHGS % (For Selling)',
                      controller.customerData[
                              'Total Fare CHGS % (For Selling)'] ??
                          ''),
                  _buildInfoRow(
                      'Total Fare CHGS PKR (For Selling)',
                      controller.customerData[
                              'Total Fare CHGS PKR (For Selling)'] ??
                          ''),
                  _buildInfoRow('Party Comm %',
                      controller.customerData['Party Comm %'] ?? ''),
                  _buildInfoRow('Party Comm PKR',
                      controller.customerData['Party Comm PKR'] ?? ''),
                  _buildInfoRow('Party WHT %',
                      controller.customerData['Party WHT %'] ?? ''),
                  _buildInfoRow('Party WHT PKR',
                      controller.customerData['Party WHT PKR'] ?? ''),
                  _buildInfoRow('PKR Total Selling',
                      controller.customerData['PKR Total Selling'] ?? ''),
                  _buildInfoRow(
                      'Total', controller.customerData['Total'] ?? ''),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildsupplierDataDetailsTab() {
    return Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'supplierData Information',
                content: [
                  _buildInfoRow('supplierData Account',
                      controller.supplierData['Supplier Account'] ?? ''),
                  _buildInfoRow('From', controller.supplierData['From'] ?? ''),
                  _buildInfoRow('Consultant Name',
                      controller.supplierData['Consultant Name'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Commission & Charges',
                content: [
                  _buildInfoRow('Airline Comm %',
                      controller.supplierData['Airline Comm %'] ?? ''),
                  _buildInfoRow('Airline Comm PKR',
                      controller.supplierData['Airline Comm PKR'] ?? ''),
                  _buildInfoRow('Airline WHT %',
                      controller.supplierData['Airline WHT %'] ?? ''),
                  _buildInfoRow('Airline WHT PKR',
                      controller.supplierData['Airline WHT PKR'] ?? ''),
                  _buildInfoRow(
                      'PSF %', controller.supplierData['PSF %'] ?? ''),
                  _buildInfoRow(
                      'PSF PKR', controller.supplierData['PSF PKR'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Financial Summary',
                content: [
                  _buildInfoRow('PKR Total Buying',
                      controller.supplierData['PKR Total Buying'] ?? ''),
                  _buildInfoRow(
                      'Profit', controller.supplierData['Profit'] ?? ''),
                  _buildInfoRow('Loss', controller.supplierData['Loss'] ?? ''),
                ],
              ),
            ],
          ),
        ));
  }

  // Keep all the existing helper widget methods (_buildTaxBox, _buildDateField, _buildInfoCard, _buildInfoRow, _buildTotalSection)
  // ... (copy all the widget building methods from the original code)
  Widget _buildTaxBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TColor.textField,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
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

  Widget _buildInfoCard(
      {required String title, required List<Widget> content}) {
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(children: content),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Debit',
                  style: TextStyle(
                    color: TColor.third,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '11.00',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Credit',
                  style: TextStyle(
                    color: TColor.secondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '11.00',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
