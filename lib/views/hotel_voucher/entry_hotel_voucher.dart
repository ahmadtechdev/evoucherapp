import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/color_extension.dart';
import '../../common_widget/dart_selector2.dart';
import '../../common_widget/round_textfield.dart';
import 'entry_hotel_controller.dart';

class HotelBookingForm extends StatelessWidget {
  const HotelBookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<HotelBookingController>(
            init: HotelBookingController(),
            builder: (controller) => Column(
              children: [
                // Date and Cancellation Date Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: DateSelector2(
                          fontSize: 12,
                          initialDate: DateTime.now(),
                          onDateChanged: (DateTime value) {},
                        ),
                        // child: _buildDateField(
                        //   label: 'Today',
                        //   dateValue: controller.todayDate,
                        //   readOnly: true,
                        // ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDateField(
                          label: 'Cancellation Deadline',
                          dateValue: controller.cancellationDeadlineDate,
                          onTap: () => _selectDate(
                              context, controller.cancellationDeadlineDate),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                TabBar(
                  labelColor: TColor.primary,
                  unselectedLabelColor: TColor.secondaryText,
                  indicatorColor: TColor.primary,
                  tabs: const [
                    Tab(text: 'Customer'),
                    Tab(text: 'Booking'),
                    Tab(text: 'Supplier'),
                  ],
                ),

                // Tab View
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildCustomerTab(controller, context),
                      _buildBookingTab(controller, context),
                      _buildSupplierTab(controller, context),
                    ],
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.validateBooking()) {
                        // Proceed with booking
                      } else {
                        // Show validation error
                        Get.snackbar('Validation Error',
                            'Please fill all required fields');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Save Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Date Field Builder
  Widget _buildDateField({
    required String label,
    required Rx<DateTime?> dateValue,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Obx(() => RoundTitleTextfield(
          title: label,
          hintText: dateValue.value != null
              ? DateFormat('dd MMM, yyyy').format(dateValue.value!)
              : 'Select Date',
          readOnly: readOnly,
          right: !readOnly
              ? IconButton(
                  icon: Icon(Icons.calendar_today, color: TColor.secondary),
                  onPressed: onTap,
                )
              : null,
        ));
  }

  // Date Selection Method
  Future<void> _selectDate(
      BuildContext context, Rx<DateTime?> dateValue) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateValue.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateValue.value = picked;
    }
  }

  // Customer Details Tab
  Widget _buildCustomerTab(
      HotelBookingController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          RoundTitleTextfield(
            title: 'Customer Account',
            hintText: 'Enter Customer Account',
            onChanged: (value) => controller.customerAccount.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Pax Name',
            hintText: 'Enter Passenger Name',
            onChanged: (value) => controller.paxName.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Phone Number',
            hintText: 'Enter Phone Number',
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.phoneNo.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Hotel Name',
            hintText: 'Enter Hotel Name',
            onChanged: (value) => controller.hotelName.value = value,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: RoundTitleTextfield(
                  title: 'Country',
                  hintText: 'Enter Country',
                  onChanged: (value) => controller.country.value = value,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RoundTitleTextfield(
                  title: 'City',
                  hintText: 'Enter City',
                  onChanged: (value) => controller.city.value = value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Booking Details Tab
  Widget _buildBookingTab(
      HotelBookingController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Date Fields
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Check-in',
                  dateValue: controller.checkInDate,
                  onTap: () => _selectDate(context, controller.checkInDate),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateField(
                  label: 'Check-out',
                  dateValue: controller.checkOutDate,
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Guest Counters
          _buildCounterField(
            title: 'Nights',
            count: controller.nights,
            onIncrement: controller.incrementNights,
            onDecrement: controller.decrementNights,
          ),
          const SizedBox(height: 15),
          _buildCounterField(
            title: 'Adults',
            count: controller.adultsCount,
            onIncrement: controller.incrementAdults,
            onDecrement: controller.decrementAdults,
          ),
          const SizedBox(height: 15),
          _buildCounterField(
            title: 'Children',
            count: controller.childrenCount,
            onIncrement: controller.incrementChildren,
            onDecrement: controller.decrementChildren,
          ),
          const SizedBox(height: 15),
          _buildCounterField(
            title: 'Rooms',
            count: controller.roomsCount,
            onIncrement: controller.incrementRooms,
            onDecrement: controller.decrementRooms,
          ),
          const SizedBox(height: 15),

          // Additional Booking Details
          RoundTitleTextfield(
            title: 'Room Type',
            hintText: 'Select Room Type',
            onChanged: (value) => controller.roomType.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Meal Plan',
            hintText: 'Select Meal Plan',
            onChanged: (value) => controller.meal.value = value,
          ),
        ],
      ),
    );
  }

  // Supplier Details Tab
  Widget _buildSupplierTab(
      HotelBookingController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          RoundTitleTextfield(
            title: 'Supplier Detail',
            hintText: 'Enter Supplier Detail',
            onChanged: (value) => controller.supplierDetail.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Supplier Confirmation No',
            hintText: 'Enter Confirmation Number',
            onChanged: (value) =>
                controller.supplierConfirmationNo.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Hotel Confirmation No',
            hintText: 'Enter Hotel Confirmation Number',
            onChanged: (value) => controller.hotelConfirmationNo.value = value,
          ),
          const SizedBox(height: 15),
          RoundTitleTextfield(
            title: 'Consultant Name',
            hintText: 'Enter Consultant Name',
            onChanged: (value) => controller.consultantName.value = value,
          ),
          const SizedBox(height: 15),

          // Selling Side Financials
          Row(
            children: [
              Expanded(
                child: RoundTitleTextfield(
                  title: 'Room/Night Selling',
                  hintText: 'Enter Selling Price',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.roomPerNightSelling.value =
                      double.tryParse(value) ?? 0.0,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RoundTitleTextfield(
                  title: 'ROE Selling',
                  hintText: 'Rate of Exchange',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.roeSellingRate.value =
                      double.tryParse(value) ?? 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Buying Side Financials
          Row(
            children: [
              Expanded(
                child: RoundTitleTextfield(
                  title: 'Room/Night Buying',
                  hintText: 'Enter Buying Price',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.roomPerNightBuying.value =
                      double.tryParse(value) ?? 0.0,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RoundTitleTextfield(
                  title: 'ROE Buying',
                  hintText: 'Rate of Exchange',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.roeBuyingRate.value =
                      double.tryParse(value) ?? 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Profit and Loss
          Row(
            children: [
              Expanded(
                child: RoundTitleTextfield(
                  title: 'Total Profit',
                  hintText: 'Profit Amount',
                  readOnly: true,
                  initialValue: controller.profit.value.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RoundTitleTextfield(
                  title: 'Total Loss',
                  hintText: 'Loss Amount',
                  readOnly: true,
                  initialValue: controller.loss.value.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Counter Field Builder
  Widget _buildCounterField({
    required String title,
    required RxInt count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove, color: TColor.secondary),
            onPressed: onDecrement,
          ),
          Obx(() => Text(
                '${count.value}',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                ),
              )),
          IconButton(
            icon: Icon(Icons.add, color: TColor.secondary),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
