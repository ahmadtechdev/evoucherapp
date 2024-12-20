// entry_hotel_voucher.dart

import 'package:evoucher/views/hotel_voucher/view_hotel_voucher/view_hotel_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/accounts_dropdown.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/dart_selector2.dart';
import '../../../common_widget/round_textfield.dart';
import 'entry_ticket_controller.dart';

class EntryTicketVoucher extends StatelessWidget {
  const EntryTicketVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: GetBuilder<EntryTicketController>(
            init: EntryTicketController(),
            builder: (controller) => Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      CustomerTab(controller: controller),
                      SupplierTab(controller: controller),
                    ],
                  ),
                ),
                _buildBottomButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: TColor.primary,
      foregroundColor: TColor.white,
      title: const Text(
        'Ticket Entry Voucher',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      bottom: TabBar(
        labelColor: TColor.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: TColor.white,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Customer'),
          Tab(text: 'Supplier'),
        ],
      ),
    );
  }

  Widget _buildBottomButton(EntryTicketController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.snackbar(
            'Success',
            'Booking Saved Successfully',
            backgroundColor: TColor.secondary,
            colorText: TColor.white,
            snackPosition: SnackPosition.TOP,
          );
          Get.to(() => ViewHotalVoucher());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomerTab extends StatelessWidget {
  final EntryTicketController controller;

  const CustomerTab({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelectors(),
          const SizedBox(height: 15),
          _buildSectionTitle('Customer Details'),
          AccountDropdown(
            onChanged: (value) {
              if (value != null) controller.customerAccount.value = value;
            },
          ),
          const SizedBox(height: 15),
          _buildCustomerBasicInfo(),
          const SizedBox(height: 20),
          _buildSectionTitle('Ticket Details'),
          _buildReactiveTicketDetails(),
          const SizedBox(height: 20),
          _buildSectionTitle('Add More Taxes'),
          _buildAddMoreTaxes(),
          _buildSectionTitle('Add More Changes'),
          const SizedBox(height: 20),
          _buildAddMoreCharges(),
          const SizedBox(height: 15),
          _buildReactiveField('PKR Total Selling', controller.pkrTotalSellingController),
          const SizedBox(height: 15),
          _buildReactiveField('Total', controller.totalController),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      children: [
        Expanded(
          child: DateSelector2(
            fontSize: 12,
            label: "Date",
            initialDate: DateTime.now(),
            onDateChanged: (value) => controller.todayDate.value = value,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: DateSelector2(
            fontSize: 12,
            label: "Issuance Date",
            initialDate: DateTime.now(),
            onDateChanged: (value) => controller.issuanceDate.value = value,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
// Update the _buildCustomerBasicInfo method:

  Widget _buildCustomerBasicInfo() {
    return Column(
      children: [
        _buildTextField(
          title: 'Phone Number',
          hintText: 'Enter Phone Number',
          controller: controller.phoneNoController,
          icon: Icons.phone,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          title: 'Pax Name',
          hintText: 'Enter Passenger Name',
          controller: controller.paxNameController,
          icon: Icons.person,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          title: 'PNR',
          hintText: 'Enter PNR',
          controller: controller.pnrController,
          icon: Icons.hotel,
        ),
      ],
    );
  }

// Update the _buildReactiveTicketDetails method:

  Widget _buildReactiveTicketDetails() {
    return Column(
      children: [
        _buildReactiveField('Ticket Number', controller.ticketNumberController),
        _buildReactiveField('Airline', controller.airLineController),
        _buildReactiveField('Sector', controller.sectorController),
        _buildReactiveField('Segments', controller.segmentsController),
        _buildReactiveField('Sector Type', controller.sectorTypeController),
        _buildReactiveField('Basic Fare', controller.basicFareController),
        _buildReactiveField('Other Taxes', controller.otherTaxesController),
      ],
    );
  }

  Widget _buildAddMoreTaxes() {
    return Column(
      children: [
        Row(
          children: [
            Obx(
                  () => Checkbox(
                value: controller.isAddMoreTaxesEnabled.value,
                onChanged: (value) =>
                controller.isAddMoreTaxesEnabled.value = value ?? false,
                activeColor: TColor.primary,
              ),
            ),
            Text(
              'Add more Taxes',
              style: TextStyle(color: TColor.primaryText),
            ),
          ],
        ),
        Obx(() {
          if (!controller.isAddMoreTaxesEnabled.value) {
            return const SizedBox.shrink();
          }
          return _buildTaxFields();
        }),
      ],
    );
  }

  Widget _buildTaxFields() {
    final taxFields = [
      'EMD', 'CC', 'SP', 'RG', 'YD', 'E3', 'IO', 'YI', 'XZ', 'PK', 'ZR', 'YQ'
    ];
    return Column(
      children: taxFields
          .map((field) => _buildReactiveField(
          field, controller.getTaxController(field)))
          .toList(),
    );
  }

  Widget _buildAddMoreCharges() {
    return Column(
      children: [
        Row(
          children: [
            Obx(
                  () => Checkbox(
                value: controller.isAddMoreChangesEnabled.value,
                onChanged: (value) =>
                controller.isAddMoreChangesEnabled.value = value ?? false,
                activeColor: TColor.primary,
              ),
            ),
            Text(
              'Add more Charges',
              style: TextStyle(color: TColor.primaryText),
            ),
          ],
        ),
        Obx(() {
          if (!controller.isAddMoreChangesEnabled.value) {
            return const SizedBox.shrink();
          }
          return _buildChargeFields();
        }),
      ],
    );
  }

  Widget _buildChargeFields() {
    final chargeFields = [
      'Basic Fare CHGS %',
      'Basic Fare CHGS PKR',
      'Total Fare CHGS',
      'Total Fare CHGS PKR',
      'Party Comm %',
      'Party Comm PKR',
      'Party WHT %',
      'Party WHT PKR',
    ];
    return Column(
      children: chargeFields
          .map((field) => _buildReactiveField(
          field, controller.getChargeController(field)))
          .toList(),
    );
  }
  Widget _buildReactiveField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RoundTitleTextfield(
        title: title,
        hintText: 'Enter $title',
        controller: controller,
        keyboardType: TextInputType.number,
        left: Icon(Icons.price_change, color: TColor.secondaryText),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return RoundTitleTextfield(
      title: title,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.text,
      left: Icon(icon, color: TColor.secondaryText),
    );
  }
}

class SupplierTab extends StatelessWidget {
  final EntryTicketController controller;

  const SupplierTab({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DateSelector2(
                  fontSize: 12,
                  label: "Travel Date & Time",
                  initialDate: DateTime.now(),
                  onDateChanged: (value) =>
                  controller.travelDateTime.value = value,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: DateSelector2(
                  fontSize: 12,
                  label: "Return Date & Time",
                  initialDate: DateTime.now(),
                  onDateChanged: (value) =>
                  controller.returnDateTime.value = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildSectionTitle('Supplier Detail'),
          AccountDropdown(
            onChanged: (value) {
              if (value != null) {
                controller.supplierDetail.value = value;
              }
            },
          ),
          const SizedBox(height: 15),
          _buildSupplierBasicInfo(),
          const SizedBox(height: 20),
          _buildSectionTitle('Add More Commissions'),
          const SizedBox(height: 20),
          Row(
            children: [
              Obx(() => Checkbox(
                value: controller.isAddMoreCommissionsEnabled.value,
                onChanged: (bool? value) {
                  controller.isAddMoreCommissionsEnabled.value =
                      value ?? false;
                },
                activeColor: TColor.primary,
              )),
              Text(
                'Add more Commissions',
                style: TextStyle(color: TColor.primaryText),
              ),
            ],
          ),
          Obx(() {
            if (controller.isAddMoreCommissionsEnabled.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    _buildReactiveField('Airline Comm %',
                        controller.airLineCommController),
                    _buildReactiveField('Airline Comm PKR',
                        controller.airLineCommPKRController),
                    _buildReactiveField('Airline WHT',
                        controller.airLineWHTController),
                    _buildReactiveField('Airline WHT PKR',
                        controller.airLineWHTPKRController),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          _buildSectionTitle('Financial Details'),
          _buildSupplierFinancials(),
          const SizedBox(height: 20),
          _buildSectionTitle('Summary'),
          _buildSupplierSummary(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSupplierBasicInfo() {
    return Column(
      children: [
        _buildTextField(
          title: 'Issue From',
          hintText: 'Enter Issue From',
          icon: Icons.remove_from_queue, controller: controller.issueFromController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          title: 'Consultant Name',
          hintText: 'Enter Consultant Name',
          controller: controller.consultantNameController,
          icon: Icons.person,
        ),
      ],
    );
  }

  Widget _buildSupplierFinancials() {
    return Column(
      children: [
        _buildReactiveField('PSF %', controller.psfController),
        _buildReactiveField('PSF PKR', controller.psfPKRController),
        _buildReactiveField('Total Buying', controller.totalBuyingController),
        _buildReactiveField('Profit', controller.profitController),
        _buildReactiveField('Loss', controller.lossController),
        _buildTextField(
          title: 'Remarks',
          hintText: 'Enter Remarks',
          icon: Icons.notes, controller: controller.remarksController,
        ),
      ],
    );
  }

  Widget _buildSupplierSummary() {
    return Row(
      children: [
        Expanded(
          child: RoundTitleTextfield(
            title: 'Total Debit',
            hintText: 'Debit Amount',
            readOnly: true,
            controller: controller.totalDebitController,
            left: Icon(Icons.add_card, color: TColor.secondaryText),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: RoundTitleTextfield(
            title: 'Total Credit',
            hintText: 'Credit Amount',
            readOnly: true,
            controller: controller.totalCreditController,
            left: Icon(Icons.credit_card, color: TColor.secondaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return RoundTitleTextfield(
      title: title,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.text,
      left: Icon(icon, color: TColor.secondaryText),
    );
  }

  Widget _buildReactiveField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RoundTitleTextfield(
        title: title,
        hintText: 'Enter $title',
        controller: controller,
        keyboardType: TextInputType.number,
        left: Icon(Icons.price_change, color: TColor.secondaryText),
      ),
    );
  }
}
