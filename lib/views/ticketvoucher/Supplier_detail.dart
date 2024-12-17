import 'package:evoucher/views/ticketvoucher/ticketvoucherControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/round_textfield.dart';

class SupplierDetail extends StatelessWidget {
  final TicketvoucherControler controller = Get.put(TicketvoucherControler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
                        'Supplier Details',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildDropdownField(
                                  items: controller.airlines,
                                  value: controller
                                          .selectedAirline.value.isNotEmpty
                                      ? controller.selectedAirline.value
                                      : null,
                                  onChanged: (value) =>
                                      controller.selectedAirline.value = value!,
                                  text: '',
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => _buildDropdownField(
                                  items: controller.airlines,
                                  value: controller
                                          .selectedAirline.value.isNotEmpty
                                      ? controller.selectedAirline.value
                                      : null,
                                  onChanged: (value) =>
                                      controller.selectedAirline.value = value!,
                                  text: 'Issue From',
                                )),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => _buildDropdownField(
                                  items: controller.airlines,
                                  value: controller
                                          .selectedAirline.value.isNotEmpty
                                      ? controller.selectedAirline.value
                                      : null,
                                  onChanged: (value) =>
                                      controller.selectedAirline.value = value!,
                                  text: 'Consultant Name',
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Obx(
                          () => GestureDetector(
                              onTap: () {
                                controller.Commissions.value =
                                    !controller.Commissions.value;
                              },
                              child: controller.Commissions.value
                                  ? Row(
                                      children: [
                                        Text(
                                          'Add Commissions ',
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
                                          'Add Commissions ',
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
                      SizedBox(height: 10),

                      // Add Taxes Form (Show/Hide based on controller)
                      Obx(() {
                        if (controller.Commissions.value) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller:
                                          controller.basicFareController,
                                      text: 'Airline Comm %',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTextField(
                                      controller:
                                          controller.basicFareController,
                                      text: 'Airline Comm PKR',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller:
                                          controller.basicFareController,
                                      text: 'Airline WHT %',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTextField(
                                      controller:
                                          controller.basicFareController,
                                      text: 'Airline WHT PKR',
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
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: controller.basicFareController,
                              text: 'PSF %',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: controller.basicFareController,
                              text: 'PSF PKR.',
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
                              text: 'Total Buying',
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
                              text: 'Profit',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: controller.basicFareController,
                              text: 'Loss',
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
                              text: 'Remarks',
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
                              text: 'Total Debit',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: controller.basicFareController,
                              text: 'Total Credit',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // TextField widget
  Widget _buildTextField(
      {required TextEditingController controller, required String text}) {
    return RoundTitleTextfield(title: text, controller: controller,);
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
