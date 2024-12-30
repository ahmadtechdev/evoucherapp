import 'package:evoucher/common/accounts_dropdown.dart';
import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/views/ticket_voucher/view_ticket_voucher/ticket_invoices_view/view/view_single_ticket_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evoucher/common_widget/round_text_field.dart';

class TicketViewSingleVoucher extends StatefulWidget {
  const TicketViewSingleVoucher({super.key});

  @override
  State<TicketViewSingleVoucher> createState() => _TicketViewSingleVoucherState();
}

class _TicketViewSingleVoucherState extends State<TicketViewSingleVoucher>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ViewSingleTicketVoucherController controller = Get.put(ViewSingleTicketVoucherController());

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
        title: const Text('View Ticket', style: TextStyle(color: Colors.white)),
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
                const SizedBox(width: 6),
                Expanded(
                  child: _buildDateField('Flight Date:', '24 Dec 2024'),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildDateField('Return Date:', '24 Dec 2024'),
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
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundTitleTextfield(
                title: 'Ticket Number',
                hintText: 'Ticket Number',
                controller: controller.ticketNumberController,
                keyboardType: TextInputType.text,
                left: Icon(Icons.airplane_ticket_outlined,
                    color: TColor.secondaryText),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AccountDropdown(
                      hintText: 'Airline',
                      onChanged: (value) =>
                          controller.selectedAirline.value = value ?? '',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AccountDropdown(
                      hintText: 'GDS',
                      onChanged: (value) =>
                          controller.selectedGDS.value = value ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                title: 'Basic Information',
                content: [
                  _buildInfoRow('Customer Account',
                      controller.customerData['Customer Account'] ?? ''),
                  _buildInfoRow(
                      'PAX Name', controller.customerData['PAX Name'] ?? ''),
                  _buildInfoRow('PNR', controller.customerData['PNR'] ?? ''),
                  _buildInfoRow('Ticket Number',
                      controller.customerData['Ticket Number'] ?? ''),
                  _buildInfoRow(
                      'Airline', controller.customerData['Airline'] ?? ''),
                  _buildInfoRow(
                      'Sector', controller.customerData['Sector'] ?? ''),
                  _buildInfoRow(
                      'Segments', controller.customerData['Segments'] ?? ''),
                  _buildInfoRow('Sector Type',
                      controller.customerData['Sector Type'] ?? ''),
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
          )),
    );
  }

  Widget _buildSupplierDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Supplier Information',
                content: [
                  _buildInfoRow('Supplier Account',
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
                  _buildInfoRow(
                      'Remark', controller.supplierData['Remark'] ?? ''),
                ],
              ),
            ],
          )),
    );
  }

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
