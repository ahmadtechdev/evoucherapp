// entry_hotel_voucher.dart

import 'package:evoucher/views/hotel_voucher/view_hotel_voucher/view_hotel_voucher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/accounts_dropdown.dart';
import '../../common/color_extension.dart';
import '../../common_widget/dart_selector2.dart';
import '../../common_widget/date_range_selector.dart';
import '../../common_widget/round_textfield.dart';
import 'entry_hotel_controller.dart';

class EntryHotelVoucher extends StatelessWidget {
  const EntryHotelVoucher({super.key});

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
        'Hotel Entry Voucher',
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
      child: GetBuilder<EntryHotelController>(
        init: EntryHotelController(),
        builder: (controller) => Obx(
              () => Column(
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
      ),
    );
  }

  Widget _buildTopDateSection(EntryHotelController controller) {
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

  Widget _buildCustomerTab(EntryHotelController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Customer Information'),
          AccountDropdown(
            onChanged: (value) {
              if (value != null) {}
            },
          ),
          const SizedBox(height: 15),
          _buildCustomerBasicInfo(controller),
          const SizedBox(height: 20),

          _buildSectionTitle('Booking Details'),
          CustomDateRangeSelector(
            dateRange: controller.dateRange.value,
            onDateRangeChanged: controller.updateDateRange,
            nights: controller.nights.value,
            onNightsChanged: controller.updateNights,
          ),
          const SizedBox(height: 15),
          _buildRoomDetails(controller),
          const SizedBox(height: 20),

          _buildSectionTitle('Guest Information'),
          _buildGuestCounters(controller),
          const SizedBox(height: 20),

          _buildSectionTitle('Financial Details'),
          _buildFinancialDetails(controller),
          // Additional Details Section
          const SizedBox(height: 20),
          _buildSectionTitle('Debit Receiving Account'),
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

  Widget _buildSupplierTab(EntryHotelController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Supplier Information'),
          AccountDropdown(
            onChanged: (value) {
              if (value != null) {}
            },
          ),
          const SizedBox(height: 15),
          _buildSupplierBasicInfo(controller),
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

  Widget _buildCustomerBasicInfo(EntryHotelController controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          controller: controller.phoneNo,
          title: 'Phone Number',
          hintText: 'Enter Phone Number',
          keyboardType: TextInputType.phone,
          left: Icon(Icons.phone, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.paxName,
          title: 'Pax Name',
          hintText: 'Enter Passenger Name',
          left: Icon(Icons.person, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.hotelName,
          title: 'Hotel Name',
          hintText: 'Enter Hotel Name',
          left: Icon(Icons.hotel, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.country,
                title: 'Country',
                hintText: 'Enter Country',
                left: Icon(Icons.flag, color: TColor.secondaryText),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                controller: controller.city,
                title: 'City',
                hintText: 'Enter City',
                left: Icon(Icons.location_city, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomDetails(EntryHotelController controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          title: 'Room Type',
          hintText: 'Select Room Type',
          onChanged: (value) => controller.roomType.value = value,
          left: Icon(Icons.bed, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          title: 'Meal Plan',
          hintText: 'Select Meal Plan',
          onChanged: (value) => controller.meal.value = value,
          left: Icon(Icons.restaurant, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        _buildCounterField(
          title: 'Rooms/Beds',
          count: controller.roomsCount,
          onIncrement: () => controller.roomsCount.value++,
          onDecrement: () {
            if (controller.roomsCount.value > 1) {
              controller.roomsCount.value--;
            }
          },
        ),
      ],
    );
  }

  Widget _buildGuestCounters(EntryHotelController controller) {
    return Column(
      children: [
        _buildCounterField(
          title: 'Adults',
          count: controller.adultsCount,
          onIncrement: () => controller.adultsCount.value++,
          onDecrement: () {
            if (controller.adultsCount.value > 1) {
              controller.adultsCount.value--;
            }
          },
          icon: Icons.person,
        ),
        const SizedBox(height: 15),
        _buildCounterField(
          title: 'Children',
          count: controller.childrenCount,
          onIncrement: () => controller.childrenCount.value++,
          onDecrement: () {
            if (controller.childrenCount.value > 0) {
              controller.childrenCount.value--;
            }
          },
          icon: Icons.child_care,
        ),
      ],
    );
  }

  Widget _buildFinancialDetails(EntryHotelController controller) {
    return Column(
      children: [
        Container(
            child: RoundTitleTextfield(
              controller: controller.roomPerNightSelling,
              title: 'Room Per Night Rate',
              hintText: 'Enter rate per night',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.calculateCustomerSide();
                //
              },
              left: Icon(Icons.attach_money, color: TColor.secondaryText),
            )),
        const SizedBox(height: 15),
        Obx(() => RoundTitleTextfield(
          title: 'Total Sale Amount',
          hintText: 'Enter sale amount',
          keyboardType: TextInputType.number,
          initialValue: controller.totalSellingAmount.value == 0.0
              ? ''
              : controller.totalSellingAmount.value.toStringAsFixed(0),
          onChanged: (value) {
            double parsedValue = double.tryParse(value) ?? 0.0;
            controller.totalSellingAmount.value = parsedValue;
          },
          left: Icon(Icons.attach_money, color: TColor.secondaryText),
        )),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                  child: RoundTitleTextfield(
                    controller: controller.roeSellingRate,
                    title: 'Exchange Rate',
                    hintText: 'Enter ROE',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.calculateCustomerSide();
                    },
                    left:
                    Icon(Icons.currency_exchange, color: TColor.secondaryText),
                  )),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                title: 'Currency',
                hintText: 'Enter currency',
                onChanged: (value) => controller.sellingCurrency.value = value,
                left: Icon(Icons.money, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Obx(() => RoundTitleTextfield(
          title: 'PKR Total Selling',
          hintText: 'Enter total selling',
          keyboardType: TextInputType.number,
          initialValue: controller.pkrTotalSelling.value == 0.0
              ? ''
              : controller.pkrTotalSelling.value.toStringAsFixed(2),
          onChanged: (value) {
            double parsedValue = double.tryParse(value) ?? 0.0;
            controller.pkrTotalSelling.value = parsedValue;
          },
          left: Icon(Icons.attach_money, color: TColor.secondaryText),
        )),
      ],
    );
  }

  Widget _buildSupplierBasicInfo(EntryHotelController controller) {
    return Column(
      children: [
        RoundTitleTextfield(
          controller: controller.supplierConfirmationNo,
          title: 'Supplier Confirmation',
          hintText: 'Enter Confirmation Number',
          left: Icon(Icons.confirmation_number, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.hotelConfirmationNo,
          title: 'Hotel Confirmation',
          hintText: 'Enter Hotel Confirmation',
          left: Icon(Icons.hotel, color: TColor.secondaryText),
        ),
        const SizedBox(height: 15),
        RoundTitleTextfield(
          controller: controller.consultantName,
          title: 'Consultant Name',
          hintText: 'Enter Consultant Name',
          left: Icon(Icons.person, color: TColor.secondaryText),
        ),
      ],
    );
  }

  // Similar changes for Supplier Financials
  Widget _buildSupplierFinancials(EntryHotelController controller) {
    return Column(
      children: [
        Container(
            child: RoundTitleTextfield(
              controller: controller.roomPerNightBuying,
              title: 'Room/Night Buying',
              hintText: 'Enter Price',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.calculateSupplierSide();
              },
              left: Icon(Icons.shopping_cart, color: TColor.secondaryText),
            )),
        const SizedBox(height: 15),
        Container(
            child: RoundTitleTextfield(
              controller: controller.totalBuyingAmount,
              title: 'Total Buying Amount',
              hintText: 'Enter Amount',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.calculateSupplierSide();
              },
              left: Icon(Icons.calculate, color: TColor.secondaryText),
            )),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                  child: RoundTitleTextfield(
                    controller: controller.roebuyingRate,
                    title: 'Exchange Rate',
                    hintText: 'Enter ROE',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.calculateSupplierSide();
                    },
                    left:
                    Icon(Icons.currency_exchange, color: TColor.secondaryText),
                  )),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: RoundTitleTextfield(
                title: 'Currency',
                hintText: 'Enter currency',
                onChanged: (value) => controller.sellingCurrency.value = value,
                left: Icon(Icons.money, color: TColor.secondaryText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Obx(() => RoundTitleTextfield(
          title: 'Pkr Total Buying',
          hintText: 'Enter buying Amount',
          keyboardType: TextInputType.number,
          initialValue: controller.pkrTotalBuying.value == 0.0
              ? ''
              : controller.pkrTotalBuying.value.toStringAsFixed(2),
          onChanged: (value) {
            double parsedValue = double.tryParse(value) ?? 0.0;
            controller.pkrTotalBuying.value = parsedValue;
          },
          left: Icon(Icons.calculate, color: TColor.secondaryText),
        )),
      ],
    );
  }

  // Update the supplier summary to be fully reactive
  Widget _buildSupplierSummary(EntryHotelController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                title: 'Total Profit',
                hintText: 'Profit Amount',
                readOnly: true,
                initialValue: controller.profit.value.toStringAsFixed(2),
                left: Icon(Icons.trending_up, color: TColor.secondary),
              )),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                title: 'Total Loss',
                hintText: 'Loss Amount',
                readOnly: true,
                initialValue: controller.loss.value.toStringAsFixed(2),
                left: Icon(Icons.trending_down, color: TColor.third),
              )),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                title: 'Total Debit',
                hintText: 'Debit Amount',
                readOnly: true,
                initialValue:
                controller.pkrTotalBuying.value.toStringAsFixed(0),
                left: Icon(Icons.add_card, color: TColor.secondaryText),
              )),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(() => RoundTitleTextfield(
                title: 'Total Credit',
                hintText: 'Credit Amount',
                readOnly: true,
                initialValue:
                controller.pkrTotalBuying.value.toStringAsFixed(0),
                left: Icon(Icons.credit_card, color: TColor.secondaryText),
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterField({
    required String title,
    required RxInt count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: TColor.secondaryText, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: TColor.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: TColor.primary),
                  onPressed: onDecrement,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Obx(() => Text(
                      '${count.value}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: TColor.primary),
                  onPressed: onIncrement,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(EntryHotelController controller) {
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
