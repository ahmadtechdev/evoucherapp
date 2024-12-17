import 'package:evoucher/views/ticketvoucher/ticketvoucherControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetail extends StatelessWidget {
  final TicketvoucherControler controller = Get.put(TicketvoucherControler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.white,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Existing rows
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.ticketNumberController,
                            text: 'Ticket(Optional)',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _buildDropdownField(
                                items: controller.airlines,
                                value:
                                    controller.selectedAirline.value.isNotEmpty
                                        ? controller.selectedAirline.value
                                        : null,
                                onChanged: (value) =>
                                    controller.selectedAirline.value = value!,
                                text: 'Airline',
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Sector, Segments, Sector Type Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.sectorController,
                            text: 'Sector',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _buildDropdownField(
                                items: controller.sectorTypes,
                                value: controller.selectedSectorType.value,
                                onChanged: (value) => controller
                                    .selectedSectorType.value = value!,
                                text: 'Sector Type',
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: controller.basicFareController,
                            text: 'Basic Fare',
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 70,
                          child: _buildTextField(
                            controller: controller.basicFareController,
                            text: 'Segment',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: controller.otherTaxesController,
                            text: 'Other Taxes',
                          ),
                        ),
                      ],
                    ),

                    // Toggle "Add Taxes" button
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Obx(
                        () => GestureDetector(
                            onTap: () {
                              controller.isTaxFormVisible.value =
                                  !controller.isTaxFormVisible.value;
                            },
                            child: controller.isTaxFormVisible.value
                                ? Row(
                                    children: [
                                      Text(
                                        'Add Taxes',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_up_outlined,
                                        color: Colors.black,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Add Taxes',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.black,
                                      )
                                    ],
                                  )),
                      ),
                    ),

                    // Add Taxes Form (Show/Hide based on controller)
                    Obx(() {
                      if (controller.isTaxFormVisible.value) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'EMD',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'CC',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'RG',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'SP',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'YD',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'E3',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: '1O',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'YI',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'XZ',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'PK',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'ZR',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'PQ',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return SizedBox(); // If not visible, return empty SizedBox
                      }
                    }),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Obx(
                        () => GestureDetector(
                            onTap: () {
                              controller.morecharges.value =
                                  !controller.morecharges.value;
                            },
                            child: controller.morecharges.value
                                ? Row(
                                    children: [
                                      Text(
                                        'Add Charges',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_up_outlined,
                                        color: Colors.black,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Add Charges',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      )
                                    ],
                                  )),
                      ),
                    ),

                    // Add Taxes Form (Show/Hide based on controller)
                    Obx(() {
                      if (controller.morecharges.value) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Basic Fare CHGS %',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Basic Fare CHGS PKR',
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Total Fare CHGS PKR',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'Total Fare CHGS %',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Party Comm %',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Party Comm PKR',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'Party WHT %',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'Party WHT PKR',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.basicFareController,
                                    text: 'PKR Total Selling',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.otherTaxesController,
                                    text: 'Total',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return SizedBox(); // If not visible, return empty SizedBox
                      }
                    }),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // TextField widget
  Widget _buildTextField(
      {required TextEditingController controller, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          height: 50,
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Dropdown field widget
  Widget _buildDropdownField({
    required String text,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          height: 50,
          child: DropdownButtonFormField<String>(
            hint: Text(items[0].toString()),
            value: value,
            dropdownColor: Colors.white,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
