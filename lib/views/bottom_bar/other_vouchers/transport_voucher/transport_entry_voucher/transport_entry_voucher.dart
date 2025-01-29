import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../common/accounts_dropdown.dart';
import '../../../../../common/color_extension.dart';
import '../../../../../common_widget/round_text_field.dart';
import 'controller/transport_entry_voucher_controller.dart';
import 'models/models.dart';

class TransportEntryVoucherScreen extends StatelessWidget {
  final controller = Get.put(TransportBookingController());

   TransportEntryVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Booking',
            style: TextStyle(color: TColor.white, fontWeight: FontWeight.bold)),
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        elevation: 0.5,
        shadowColor: TColor.primary.withOpacity(0.3),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildTransportSection(),
              const SizedBox(height: 24),
              _buildFlightSection(),
              const SizedBox(height: 24),
              const RoundTitleTextfield(
                title: 'Note',
                hintText: '',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              _buildSummarySection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 8,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            RoundTitleTextfield(
              title: 'Date',
              readOnly: true,
              controller: TextEditingController(
                text: DateFormat('MM/dd/yyyy').format(controller.date.value),
              ),
              right: IconButton(
                icon: Icon(Icons.calendar_today, color: TColor.primary),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: controller.date.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.date.value = picked;
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            RoundTitleTextfield(
              title: 'Customer',
              hintText: 'Select Customer',
              right: Icon(Icons.arrow_drop_down, color: TColor.primary),
            ),
            const SizedBox(height: 16),
            const RoundTitleTextfield(
              title: 'Passenger Name',
              hintText: 'Enter passenger name',
            ),
            const SizedBox(height: 16),
            const RoundTitleTextfield(
              title: 'Contact Number',
              hintText: 'Enter contact number',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transport Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TColor.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.transportList.map((transport) => _buildTransportCard(transport)),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Transport'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondary,
              foregroundColor: TColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 4,
              shadowColor: TColor.secondary.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.addTransport();
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildTransportCard(TransportModel transport) {
    return Card(
      elevation: 8,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.6),
      margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with transport number and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transport #${controller.transportList.indexOf(transport) + 1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.secondary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: TColor.third, size: 28),
                  onPressed: () => controller.removeTransport(transport),
                ),
              ],
            ),
            Divider(color: TColor.secondary.withOpacity(0.2), height: 30),

            // Supplier Account (Full width)
            AccountDropdown(
              initialValue: transport.supplierAccount,
              hintText: 'Select supplier',
              subHeadName: 'Transport Suppliers',
              primaryColor: TColor.secondary,
              onChanged: (value) {
                // Handle supplier change
              },
            ),
            const SizedBox(height: 20),
            RoundTitleTextfield(
              title: 'Flight No',
              hintText: 'Enter flight number',
              initialValue: transport.flightNo,
            ),
            const SizedBox(height: 20),
            RoundTitleTextfield(
              title: 'Select Transport',
              hintText: 'Transport Values',
              initialValue: transport.flightNo,
            ),
            const SizedBox(height: 20),
            // Flight and Travel Date
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RoundTitleTextfield(
                    title: 'Travel Date',
                    readOnly: true,
                    initialValue: DateFormat('MM/dd/yyyy').format(transport.travelDate),
                    right: Icon(Icons.calendar_today, color: TColor.secondary),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: RoundTitleTextfield(
                    title: 'Travel Time',
                    readOnly: true,
                    initialValue: DateFormat('MM/dd/yyyy').format(transport.travelDate),
                    right: Icon(Icons.timer, color: TColor.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Route (Full width)
            RoundTitleTextfield(
              title: 'Route',
              hintText: 'Enter route',
              initialValue: transport.route,
            ),
            const SizedBox(height: 20),

            // Registration and Capacity
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RoundTitleTextfield(
                    title: 'Registration Number',
                    hintText: 'Enter registration',
                    initialValue: transport.transportReg,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: RoundTitleTextfield(
                    title: 'Capacity',
                    hintText: 'Enter capacity',
                    initialValue: transport.capacity,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Driver Information
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RoundTitleTextfield(
                    title: 'Driver Name',
                    hintText: 'Enter driver name',
                    initialValue: transport.driverName,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: RoundTitleTextfield(
                    title: 'Driver Number',
                    hintText: 'Enter driver number',
                    initialValue: transport.driverNumber,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rates Section
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: TColor.textField.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: TColor.secondary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  AccountDropdown(
                    hintText: 'Buy Currency',
                    initialValue: transport.buyingCurrency,
                    primaryColor: TColor.secondary,
                    showSearch: false,
                  ),
                  const SizedBox(height: 15),
                  // Buy Rate Information
                  Row(
                    children: [
                      Expanded(
                        child: RoundTitleTextfield(
                          title: 'Buy Rate',
                          hintText: 'Enter buy rate',
                          initialValue: transport.buyRate.toString(),
                          keyboardType: TextInputType.number,

                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: RoundTitleTextfield(
                          title: 'Buy ROE',
                          hintText: 'Enter ROE',
                          initialValue: transport.buyingROE.toString(),
                          keyboardType: TextInputType.number,

                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 15),
                  RoundTitleTextfield(
                    title: 'Total Buy ROE',
                    hintText: 'Enter ROE',
                    initialValue: transport.sellingROE.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  AccountDropdown(
                    hintText: 'Sell Currency',
                    initialValue: transport.sellingCurrency,
                    primaryColor: TColor.secondary,
                    showSearch: false,
                  ),
                  const SizedBox(height: 15),
                  // Sell Rate Information
                  Row(
                    children: [
                      Expanded(
                        child: RoundTitleTextfield(
                          title: 'Sell Rate',
                          hintText: 'Enter sell rate',
                          initialValue: transport.sellRate.toString(),
                          keyboardType: TextInputType.number,

                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: RoundTitleTextfield(
                          title: 'Sell ROE',
                          hintText: 'Enter ROE',
                          initialValue: transport.sellingROE.toString(),
                          keyboardType: TextInputType.number,

                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 15),
                  RoundTitleTextfield(
                    title: 'Total Sell ROE',
                    hintText: 'Enter ROE',
                    initialValue: transport.sellingROE.toString(),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flight Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: TColor.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.flightList.map((flight) => _buildFlightCard(flight)),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Flight'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.fourth,
              foregroundColor: TColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 4,
              shadowColor: TColor.fourth.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.addFlight();
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildFlightCard(FlightModel flight) {
    return Card(
      elevation: 8,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.6),
      margin: const EdgeInsets.only(bottom: 20,  left: 4, right: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with flight number and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Flight #${controller.flightList.indexOf(flight) + 1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColor.fourth,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: TColor.third,
                    size: 28,
                  ),
                  onPressed: () => controller.removeFlight(flight),
                ),
              ],
            ),
            Divider(color: TColor.fourth.withOpacity(0.2), height: 30),

            // Flight Number
            RoundTitleTextfield(
              title: 'Flight#',
              hintText: 'Enter flight number',
              initialValue: flight.flightNumber,
              onChanged: (value) {
                controller.updateFlightDetails(
                  controller.flightList.indexOf(flight),
                  {'flightNumber': value},
                );
              },
            ),
            const SizedBox(height: 20),

            // Departure Row
            Row(
              children: [
                // Departure Date
                Expanded(
                  flex: 2,
                  child: RoundTitleTextfield(
                    title: 'Dep Date',
                    readOnly: true,
                    initialValue: DateFormat('MM/dd/yyyy').format(flight.departureDate),
                    right: Icon(Icons.calendar_today, color: TColor.fourth, size: 20),
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'departureDate': value},
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Departure Time
                Expanded(
                  flex: 1,
                  child: RoundTitleTextfield(
                    title: 'Dep Time',
                    readOnly: true,
                    initialValue: flight.departureTime,
                    right: Icon(Icons.access_time, color: TColor.fourth, size: 20),
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'departureTime': value},
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sectors Row
            Row(
              children: [
                // Sector From
                Expanded(
                  child: AccountDropdown(
                    hintText: 'Sector From',
                    initialValue: flight.sectorFrom,
                    primaryColor: TColor.fourth,
                    showSearch: true,
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'sectorFrom': value},
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Sector To
                Expanded(
                  child: AccountDropdown(
                    hintText: 'Sector To ',
                    initialValue: flight.sectorTo,
                    primaryColor: TColor.fourth,
                    showSearch: true,
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'sectorTo': value},
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Arrival Row
            Row(
              children: [
                // Arrival Date
                Expanded(
                  flex: 2,
                  child: RoundTitleTextfield(
                    title: 'Arr Date',
                    readOnly: true,
                    initialValue: DateFormat('MM/dd/yyyy').format(flight.arrivalDate),
                    right: Icon(Icons.calendar_today, color: TColor.fourth, size: 20),
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'arrivalDate': value},
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Arrival Time
                Expanded(
                  flex: 1,
                  child: RoundTitleTextfield(
                    title: 'Arr Time',
                    readOnly: true,
                    initialValue: flight.arrivalTime,
                    right: Icon(Icons.access_time, color: TColor.fourth, size: 20),
                    onChanged: (value) {
                      controller.updateFlightDetails(
                        controller.flightList.indexOf(flight),
                        {'arrivalTime': value},
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      elevation: 8,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            _buildSummaryRow('Total Buying', 'PKR 1000 '),
            const SizedBox(height: 12),
            _buildSummaryRow('Total Selling', 'PKR 800'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: TColor.primary.withOpacity(0.2)),
            ),
            _buildSummaryRow('Profit Lose', 'PKR 200 ', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: TColor.primaryText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? TColor.primary : TColor.primaryText,
          ),
        ),
      ],
    );
  }
}