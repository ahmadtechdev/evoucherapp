// entry_hotel_voucher.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/accounts_dropdown.dart';
import '../../../../common/color_extension.dart';
import '../../../../common_widget/dart_selector2.dart';
import '../../../../common_widget/round_text_field.dart';
import '../../../../common_widget/snackbar.dart';

import 'entry_visa_voucher_controller.dart';

class VisaVoucher extends StatelessWidget {
  const VisaVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: TColor.primary,
      foregroundColor: TColor.white,
      title: const Text(
        'Visa Entry Voucher',
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

  Widget _buildBody() {
    return SafeArea(
      child: GetBuilder<VisaVoucherControler>(
        init: VisaVoucherControler(),
        builder: (controller) => Column(
          children: [
            _buildTopDateSection(controller),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCustomerTab(controller),
                  _buildSupplierTab(controller),
                ],
              ),
            ),
            _buildBottomButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDateSection(VisaVoucherControler controller) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DateSelector2(
              fontSize: 12,
              label: "Voucher Date",
              initialDate: DateTime.now(),
              onDateChanged: (value) => controller.todayDate.value = value,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: DateSelector2(
              fontSize: 12,
              label: "Cancellation Deadline",
              initialDate: DateTime.now(),
              onDateChanged: (value) =>
                  controller.cancellationDeadlineDate.value = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerTab(VisaVoucherControler controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Customer Information'),
          AccountDropdown(
            subHeadName: "Customers",
            hintText: 'Select Customer Account',
            onChanged: (value) {
              if (value != null) {
                // controller.customerAccount.value =value;
              }
            },
          ),
          const SizedBox(height: 15),
          _buildCustomerBasicInfo(controller),
          const SizedBox(height: 20),

          _buildSectionTitle('Financial Details'),
          _buildFinancialDetails(controller),
          // Additional Details Section
          const SizedBox(height: 20),
          Row(
            children: [
              Obx(() => Checkbox(
                    value: controller.isAdditionalDetailsEnabled.value,
                    onChanged: (bool? value) {
                      controller.isAdditionalDetailsEnabled.value =
                          value ?? false;
                      if (value == true) {
                        // Add first entry when checkbox is checked
                        if (controller.additionalDetails.isEmpty) {
                          controller.addAdditionalDetail();
                        }
                      } else {
                        // Clear all additional details when unchecked
                        controller.additionalDetails.clear();
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
            if (controller.isAdditionalDetailsEnabled.value) {
              return Column(
                children: [
                  for (int index = 0;
                      index < controller.additionalDetails.length;
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
                                    controller.addAdditionalDetail(),
                              ),
                              if (controller.additionalDetails.length > 1)
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: TColor.third),
                                  onPressed: () =>
                                      controller.removeAdditionalDetail(index),
                                ),
                            ],
                          ),
                          AccountDropdown(
                            onChanged: (value) => controller
                                .additionalDetails[index]['name'].value = value,
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
                                .additionalDetails[index]['amount']
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

  Widget _buildSupplierTab(VisaVoucherControler controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Supplier Information'),
          AccountDropdown(
            subHeadName: "Air Tickets Suppliers",
            hintText: 'Select Supplier Account',
            onChanged: (value) {
              if (value != null) {
                // controller.supplierDetail.value = value;
              }
            },
          ),
          const SizedBox(height: 15),
          AccountDropdown(
            showSearch: false,
            hintText: 'Select Consultant  Account',
            onChanged: (value) {
              if (value != null) {
                // controller.supplierDetail.value = value;
              }
            },
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Financial Details'),
          _buildSupplierFinancials(controller),
          const SizedBox(height: 20),
          _buildSectionTitle('Summary'),
          _buildSupplierSummary(controller),
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

  Widget _buildCustomerBasicInfo(VisaVoucherControler controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          controller: controller.phoneNo,
          title: 'Phone Number',
          hintText: 'Enter Phone Number',
          keyboardType: TextInputType.phone,
          // onChanged: (value) => controller.phoneNo.value = value,
          left: Icon(Icons.phone, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.customerAccount,
          title: 'Customer Name',
          hintText: 'Enter Customer Name',
          left: Icon(Icons.person, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.passportNo,
          title: 'Passport No',
          hintText: 'Enter Passport No',
          left: Icon(MdiIcons.passport, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.visaType,
          title: 'V. Type',
          hintText: 'Enter V. Type',
          left: Icon(Icons.business, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.country,

                title: 'Country',
                hintText: 'Enter Country',
                // onChanged: (value) => controller.country.value = value,
                left: Icon(Icons.flag, color: TColor.secondaryText),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.visaNo,
                title: 'Visa No:',
                hintText: 'Enter Visa No:',
                left: Icon(Icons.airplane_ticket, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialDetails(VisaVoucherControler controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          controller: controller.foreignSaleRateController,
          title: 'Foreign Sale Rate',
          hintText: 'Foreign Sale Rate',
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.calculateTotalSelling();
            // controller.suplier_calculateTotalSelling();
          },
          left: Icon(Icons.attach_money, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.roeSellingRateController,

                title: 'Exchange Rate',
                hintText: 'Enter ROE',
                keyboardType: TextInputType.number,
                //
                onChanged: (value) {
                  controller.calculateTotalSelling();
                  // controller.suplier_calculateTotalSelling();
                },
                left:
                    Icon(Icons.currency_exchange, color: TColor.secondaryText),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.sellingCurrencyController,
                title: 'Currency',
                hintText: 'Enter currency',
                left: Icon(Icons.money, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Obx(() => RoundTitleTextfield(
              controller: TextEditingController(
                  text: controller.totalSellingAmountController.value),
              title: 'Pkr Total Buying',
              hintText: 'Enter buying Amount',
              readOnly: true,
              onChanged: (value) {},
              left: Icon(Icons.calculate, color: TColor.secondaryText),
            )),
      ],
    );
  }

  // Similar changes for Supplier Financials
  Widget _buildSupplierFinancials(VisaVoucherControler controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          controller: controller.foreignPurchaseRateController,
          title: 'Foreign Purchsae Rate',
          hintText: 'Foreign Purchsae Rate',
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.supplierCalculateTotalSelling(),
          left: Icon(Icons.confirmation_number, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.supplierROESellingRateController,

                title: 'Exchange Rate',
                hintText: 'Enter ROE',
                keyboardType: TextInputType.number,
                // initialValue: controller.roeSellingRate.value == 1.0
                //     ? ''
                //     : controller.roeSellingRate.value.toStringAsFixed(2),
                onChanged: (value) =>
                    controller.supplierCalculateTotalSelling(),

                left:
                    Icon(Icons.currency_exchange, color: TColor.secondaryText),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.sellingCurrencyController,
                title: 'Currency',
                hintText: 'Enter currency',
                left: Icon(Icons.money, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Obx(() => RoundTitleTextfield(
              controller:
                  TextEditingController(text: controller.pkrTotalBuying.value),
              title: 'Pkr Total Buying',
              hintText: 'Enter buying Amount',
              readOnly: true,
              onChanged: (value) {},
              left: Icon(Icons.calculate, color: TColor.secondaryText),
            )),
      ],
    );
  }

  // Update the supplier summary to be fully reactive
  Widget _buildSupplierSummary(VisaVoucherControler controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => RoundTitleTextfield(
                  textClr: TColor.secondary,
                  controller:
                      TextEditingController(text: controller.profit.value),
                  title: 'Total Profit',
                  hintText: 'Profit Amount',
                  readOnly: true,
                  left: Icon(Icons.trending_up, color: TColor.secondary),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(
                () => RoundTitleTextfield(
                  textClr: TColor.third,
                  controller:
                      TextEditingController(text: controller.loss.value),
                  title: 'Total Loss',
                  hintText: 'Loss Amount',
                  readOnly: true,
                  left: Icon(Icons.trending_down, color: TColor.third),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                    controller: TextEditingController(
                        text: controller.pkrTotalBuying.value),
                    title: 'Total Debit',
                    hintText: 'Debit Amount',
                    readOnly: true,
                    left: Icon(Icons.add_card, color: TColor.secondaryText),
                  )),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                    controller: TextEditingController(
                        text: controller.pkrTotalBuying.value),
                    title: 'Total Credit',
                    hintText: 'Credit Amount',
                    readOnly: true,
                    left: Icon(Icons.credit_card, color: TColor.secondaryText),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildCounterField({
  //   required String title,
  //   required RxInt count,
  //   required VoidCallback onIncrement,
  //   required VoidCallback onDecrement,
  //   IconData? icon,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: TColor.textField,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Row(
  //       children: [
  //         if (icon != null) Icon(icon, color: TColor.secondaryText, size: 20),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: Text(
  //             title,
  //             style: TextStyle(
  //               color: TColor.primaryText,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //             color: TColor.white,
  //             borderRadius: BorderRadius.circular(10),
  //             border: Border.all(color: TColor.primary.withOpacity(0.3)),
  //           ),
  //           child: Row(
  //             children: [
  //               IconButton(
  //                 icon: Icon(Icons.remove, color: TColor.primary),
  //                 onPressed: onDecrement,
  //                 padding: const EdgeInsets.all(8),
  //                 constraints: const BoxConstraints(),
  //               ),
  //               SizedBox(
  //                 width: 40,
  //                 child: Center(
  //                   child: Text(
  //                     '${count.value}',
  //                     style: TextStyle(
  //                       color: TColor.primaryText,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               IconButton(
  //                 icon: Icon(Icons.add, color: TColor.primary),
  //                 onPressed: onIncrement,
  //                 padding: const EdgeInsets.all(8),
  //                 constraints: const BoxConstraints(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomButton(VisaVoucherControler controller) {
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
          // Add validation logic here
          CustomSnackBar(message: "Calculations are functional, but saving is not available yet.", backgroundColor: TColor.fourth).show();

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
          'Save Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
