import 'package:evoucher/views/ticketvoucher/Supplier_detail.dart';
import 'package:evoucher/views/ticketvoucher/customer_detail.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/dart_selector2.dart';

class TictekVoucher extends StatelessWidget {
  const TictekVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: SafeArea(
            child: Column(
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
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          child: DateSelector2(
                            fontSize: 12,
                            initialDate: DateTime.now(),
                            onDateChanged: (DateTime value) {},
                          ),
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
                    Tab(text: 'Supplier'),
                  ],
                ),

                // Tab View
                Expanded(
                  child: TabBarView(
                    children: [
                      CustomerDetail(),
                      SupplierDetail(),
                    ],
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // if () {
                      //   // Proceed with booking
                      // } else {
                      //   // Show validation error
                      //   Get.snackbar('Validation Error',
                      //       'Please fill all required fields');
                      // }
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
                          color: Colors.white),
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
}
