// entry_hotel_voucher.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/accounts_dropdown.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/custom_dropdown.dart';
import '../../../common_widget/dart_selector2.dart';
import '../../../common_widget/round_text_field.dart';
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
          controller.saveTicketVoucher();
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

  const CustomerTab({super.key, required this.controller});

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
          _buildCustomerDetails(),
          const SizedBox(height: 15),
          _buildTicketDetails(),
          _buildTaxesSection(),
          _buildChargesSection(),
          _buildCommissionSection(),
          _buildTotalsSection(),
          _buildSectionTitle('Debit Receiving Account'),
          const SizedBox(height: 15),
          Row(
            children: [
              Obx(() => Checkbox(
                    value: controller.isTicketReceivingDetailsEnabled.value,
                    onChanged: (bool? value) {
                      controller.isTicketReceivingDetailsEnabled.value =
                          value ?? false;
                      if (value == true) {
                        // Add first entry when checkbox is checked
                        if (controller.ticketReceivingDetails.isEmpty) {
                          controller.addTicketReceivingDetail();
                        }
                      } else {
                        // Clear all additional details when unchecked
                        controller.ticketReceivingDetails.clear();
                      }
                    },
                    activeColor: TColor.primary,
                  )),
              Text(
                'Any Receiving',
                style: TextStyle(color: TColor.primaryText),
              ),
            ],
          ),
          Obx(() {
            if (controller.isTicketReceivingDetailsEnabled.value) {
              return Column(
                children: [
                  for (int index = 0;
                      index < controller.ticketReceivingDetails.length;
                      index++)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Account ${index + 1}',
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: TColor.secondary),
                                onPressed: () =>
                                    controller.addTicketReceivingDetail(),
                              ),
                              if (controller.ticketReceivingDetails.length > 1)
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: TColor.third),
                                  onPressed: () => controller
                                      .removeTicketReceivingDetail(index),
                                ),
                            ],
                          ),
                          AccountDropdown(
                            onChanged: (value) => controller
                                .ticketReceivingDetails[index]['name']
                                .value = value,
                          ),
                          // RoundTitleTextfield(
                          //   title: 'Guest Name',
                          //   hintText: 'Enter Guest Name',
                          //   onChanged: (value) => controller
                          //       .additionalDetails[index]['name'].value = value,
                          //   left:
                          //       Icon(Icons.person, color: TColor.secondaryText),
                          // ),
                          const SizedBox(height: 15),
                          RoundTitleTextfield(
                            title: 'Now Receiving',
                            hintText: 'Enter Amount',
                            keyboardType: TextInputType.number,
                            onChanged: (value) => controller
                                .ticketReceivingDetails[index]['amount']
                                .value = value,
                            left:
                                Icon(Icons.email, color: TColor.secondaryText),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
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

  Widget _buildCustomerDetails() {
    return GetBuilder<EntryTicketController>(
      id: 'customer_details',
      builder: (_) => Column(
        children: [
          AccountDropdown(
            subHeadName: "Customers",
            onChanged: (value) {
              if (value != null) controller.customerAccount.value = value;
              controller.update(['customer_details']);
            },
          ),
          const SizedBox(height: 15),
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
            icon: Icons.confirmation_number,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails() {
    return GetBuilder<EntryTicketController>(
      id: 'ticket_details',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Ticket Details'),
          _buildTextField(
            title: 'Ticket Number',
            hintText: 'Enter Ticket Number',
            controller: controller.ticketNumberController,
            icon: Icons.airplane_ticket,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            title: 'Airline',
            hintText: 'Enter Airline',
            controller: controller.airLineController,
            icon: Icons.flight,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            title: 'Sector',
            hintText: 'Enter Sector',
            controller: controller.sectorController,
            icon: Icons.route,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            title: 'Segments',
            hintText: 'Enter Segments',
            controller: controller.segmentsController,
            icon: Icons.segment,
          ),
          const SizedBox(height: 15),
          // Replace your _buildTextField with this widget
          CustomDropdown(
            hint: ' Sector Type',
            items: controller.sectorTypes,
            selectedItemId: controller.sectorTypeController.text,
            onChanged: (value) {
              controller.sectorTypeController.text = value!;
            },
            showSearch: false,
            enabled: true,
          ),
          ReactiveTextField(
            title: 'Basic Fare',
            controller: controller.basicFareController,
            ticketController: controller,
            onEditingComplete: () {
              controller.calculateBasicFareCHGS();
              controller.calculateTotal();
            },
          ),
          ReactiveTextField(
            title: 'Other Taxes',
            controller: controller.otherTaxesController,
            ticketController: controller,
            onEditingComplete: controller.calculateTotal,
          ),
        ],
      ),
    );
  }

  Widget _buildTaxesSection() {
    return GetBuilder<EntryTicketController>(
      id: 'taxes_section',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Add More Taxes'),
          CheckboxListTile(
            title: Text('Add more Taxes',
                style: TextStyle(color: TColor.primaryText)),
            value: controller.isAddMoreTaxesEnabled.value,
            onChanged: (value) {
              controller.isAddMoreTaxesEnabled.value = value ?? false;
              controller.update(['taxes_section']);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: TColor.primary,
          ),
          if (controller.isAddMoreTaxesEnabled.value) _buildTaxFields(),
        ],
      ),
    );
  }

  Widget _buildTaxFields() {
    final taxFields = [
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
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 24) / 2; // Calculate width for two items, considering spacing
        return Wrap(
          spacing: 8.0, // Horizontal spacing between fields
          runSpacing: 8.0, // Vertical spacing between rows
          children: taxFields.map(
                (field) {
              return SizedBox(
                width: itemWidth, // Responsive width based on device constraints
                child: ReactiveTextField(
                  title: field,
                  controller: controller.getTaxController(field),
                  ticketController: controller,
                  onEditingComplete: controller.calculateTotal,
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }



  Widget _buildChargesSection() {
    return GetBuilder<EntryTicketController>(
      id: 'charges_section',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Charges'),
          ReactiveTextField(
            title: 'Basic Fare CHGS %',
            controller: controller.basicFareCHGSController,
            ticketController: controller,
            onEditingComplete: controller.calculateBasicFareCHGS,
            isPercentage: true,
          ),
          ReactiveTextField(
            title: 'Basic Fare CHGS PKR',
            controller: controller.basicFareCHGSPKRController,
            ticketController: controller,
            onEditingComplete: controller.calculateBasicFareCHGS,
          ),
          ReactiveTextField(
            title: 'Total Fare CHGS %',
            controller: controller.totalFareCHGSController,
            ticketController: controller,
            onEditingComplete: controller.calculateTotalFareCHGS,
            isPercentage: true,
          ),
          ReactiveTextField(
            title: 'Total Fare CHGS PKR',
            controller: controller.totalFareCHGSPKRController,
            ticketController: controller,
            onEditingComplete: controller.calculateTotalFareCHGS,
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionSection() {
    return GetBuilder<EntryTicketController>(
      id: 'commission_section',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Commission'),
          ReactiveTextField(
            title: 'Party Comm %',
            controller: controller.partyCommController,
            ticketController: controller,
            onEditingComplete: controller.calculatePartyComm,
            isPercentage: true,
          ),
          ReactiveTextField(
            title: 'Party Comm PKR',
            controller: controller.partyCommPKRController,
            ticketController: controller,
            onEditingComplete: controller.calculatePartyComm,
          ),
          ReactiveTextField(
            title: 'Party WHT %',
            controller: controller.partyWHTController,
            ticketController: controller,
            onEditingComplete: controller.calculatePartyWHT,
            isPercentage: true,
          ),
          ReactiveTextField(
            title: 'Party WHT PKR',
            controller: controller.partyWHTPKRController,
            ticketController: controller,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection() {
    return GetBuilder<EntryTicketController>(
      id: 'totals_section',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Totals'),
          ReactiveTextField(
            title: 'PKR Total Selling',
            controller: controller.pkrTotalSellingController,
            ticketController: controller,
          ),
          ReactiveTextField(
            title: 'Total',
            controller: controller.totalController,
            ticketController: controller,
            readOnly: true,
          ),
        ],
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

// Updated SupplierTab class
class SupplierTab extends StatelessWidget {
  final EntryTicketController controller;

  const SupplierTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSection(),
          const SizedBox(height: 15),
          _buildSupplierDetailSection(),
          const SizedBox(height: 15),
          _buildCommissionsSection(),
          const SizedBox(height: 15),
          _buildFinancialsSection(),
          const SizedBox(height: 15),
          _buildSummarySection(),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: DateSelector2(
            fontSize: 12,
            label: "Travel Date & Time",
            initialDate: DateTime.now(),
            onDateChanged: (value) => controller.travelDateTime.value = value,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: DateSelector2(
            fontSize: 12,
            label: "Return Date & Time",
            initialDate: DateTime.now(),
            onDateChanged: (value) => controller.returnDateTime.value = value,
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Supplier Detail'),
        AccountDropdown(
          subHeadName: "Air Tickets Suppliers",
          onChanged: (value) {
            if (value != null) controller.supplierDetail.value = value;
          },
        ),
        const SizedBox(height: 15),

        CustomDropdown(
          hint: 'Issue From',
          items: controller.issueFrom,
          selectedItemId: controller.issueFromController.text,
          onChanged: (value) {
            controller.issueFromController.text = value!;
          },
          showSearch: false,
          enabled: true,
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

  Widget _buildCommissionsSection() {
    return GetBuilder<EntryTicketController>(
      id: 'supplier_commissions',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Commissions'),
          CheckboxListTile(
            title: Text('Add more Commissions',
                style: TextStyle(color: TColor.primaryText)),
            value: controller.isAddMoreCommissionsEnabled.value,
            onChanged: (value) {
              controller.isAddMoreCommissionsEnabled.value = value ?? false;
              controller.update(['supplier_commissions']);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: TColor.primary,
          ),
          if (controller.isAddMoreCommissionsEnabled.value) ...[
            ReactiveTextField(
              title: 'Airline Comm %',
              controller: controller.airLineCommController,
              ticketController: controller,
              onEditingComplete: controller.calculateAirlineComm,
              isPercentage: true,
            ),
            ReactiveTextField(
              title: 'Airline Comm PKR',
              controller: controller.airLineCommPKRController,
              ticketController: controller,
              onEditingComplete: controller.calculateAirlineComm,
            ),
            ReactiveTextField(
              title: 'Airline WHT %',
              controller: controller.airLineWHTController,
              ticketController: controller,
              onEditingComplete: controller.calculateAirlineWHT,
              isPercentage: true,
              readOnly: controller.isAirlineWHTReadOnly.value,
            ),
            ReactiveTextField(
              title: 'Airline WHT PKR',
              controller: controller.airLineWHTPKRController,
              ticketController: controller,
              readOnly: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialsSection() {
    return GetBuilder<EntryTicketController>(
      id: 'supplier_financials',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Financial Details'),
          ReactiveTextField(
            title: 'PSF %',
            controller: controller.psfController,
            ticketController: controller,
            onEditingComplete: controller.calculatePSF,
            isPercentage: true,
          ),
          ReactiveTextField(
            title: 'PSF PKR',
            controller: controller.psfPKRController,
            ticketController: controller,
            onEditingComplete: controller.calculatePSF,
          ),
          ReactiveTextField(
            title: 'Total Buying',
            controller: controller.totalBuyingController,
            ticketController: controller,
            readOnly: true,
          ),
          ReactiveTextField(
            title: 'Profit',
            controller: controller.profitController,
            ticketController: controller,
            readOnly: true,
          ),
          ReactiveTextField(
            title: 'Loss',
            controller: controller.lossController,
            ticketController: controller,
            readOnly: true,
          ),
          _buildTextField(
            title: 'Remarks',
            hintText: 'Enter Remarks',
            controller: controller.remarksController,
            icon: Icons.notes,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return GetBuilder<EntryTicketController>(
      id: 'supplier_summary',
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Summary'),
          Row(
            children: [
              Expanded(
                child: ReactiveTextField(
                  title: 'Total Debit',
                  controller: controller.totalDebitController,
                  ticketController: controller,
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ReactiveTextField(
                  title: 'Total Credit',
                  controller: controller.totalCreditController,
                  ticketController: controller,
                  readOnly: true,
                ),
              ),
            ],
          ),
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

// Improved ReactiveTextField widget with fixed input validation
class ReactiveTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final bool isPercentage;
  final EntryTicketController ticketController;

  const ReactiveTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.ticketController,
    this.onEditingComplete,
    this.readOnly = false,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EntryTicketController>(
      id: 'reactive_field_$title',
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RoundTitleTextfield(
          title: title,
          hintText: 'Enter $title',
          controller: controller,
          bgColor: _isReadOnly()
              ? TColor.readOnlyTextField
              : TColor.textField,
          textClr: _isReadOnly()
          ? TColor.readOnlyText : TColor.primaryText,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          readOnly: _isReadOnly(),
          onChanged: _handleOnChanged,
          onEditingComplete: _handleEditingComplete,
          left: Icon(
            isPercentage ? Icons.percent : Icons.price_change,
            color: TColor.secondaryText,
          ),
        ),
      ),
    );
  }

  void _handleOnChanged(String value) {
    if (value.isEmpty) return; // Allow empty field

    // Allow numbers with optional decimal point
    // This regex allows:
    // - Single digits (0-9)
    // - Multiple digits
    // - A single decimal point
    // - Numbers with decimal places
    final validNumber = RegExp(r'^\d*\.?\d*$');

    if (!validNumber.hasMatch(value)) {
      // If invalid, remove non-numeric characters except decimal point
      String sanitized = value.replaceAll(RegExp(r'[^\d.]'), '');

      // Ensure only one decimal point
      int decimalCount = '.'.allMatches(sanitized).length;
      if (decimalCount > 1) {
        sanitized = sanitized.replaceAll('.', '');
        sanitized =
            '${sanitized.substring(0, sanitized.length - 1)}.${sanitized.substring(sanitized.length - 1)}';
      }

      // Update controller only if the value has changed
      if (sanitized != controller.text) {
        controller.text = sanitized;
        // Place cursor at the end
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    }
  }

  void _handleEditingComplete() {
    if (controller.text.endsWith('.')) {
      controller.text = controller.text.replaceAll('.', '');
    }
    onEditingComplete?.call();
    ticketController.update(['reactive_field_$title']);
  }

  bool _isReadOnly() {
    switch (title) {
      case 'Basic Fare CHGS %':
      case 'Basic Fare CHGS PKR':
        return readOnly || ticketController.isBasicFareCHGSReadOnly.value;
      case 'Total Fare CHGS %':
      case 'Total Fare CHGS PKR':
        return readOnly || ticketController.isTotalFareReadOnly.value;
      case 'Party WHT PKR':
      case 'Total':
        return true;
      default:
        return readOnly;
    }
  }
}
