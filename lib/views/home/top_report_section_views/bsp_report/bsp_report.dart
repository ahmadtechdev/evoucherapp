// ticket_controller.dart remains the same as previous version

// ticket_card_listing_screen.dart
import 'package:evoucher_new/common/color_extension.dart';
import 'package:evoucher_new/common_widget/dart_selector2.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bsp_report/bsp_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketListingScreen extends StatelessWidget {
  final BspReportController controller = Get.put(BspReportController());

  TicketListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ticket Listings'),
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDateSelectors(),
          _buildTicketsList(),
          _buildTotalFooter(),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey[50],
      child: Obx(
        () => Text(
          'Dated: ${DateFormat('E, dd MMM yyyy').format(controller.startDate.value)}',
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.tickets[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket['v_number'],
                            style: TextStyle(
                              color: TColor.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          ticket['date'],
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: TColor.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          ticket['pax'],
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('Ticket', ticket['ticket_number']),
                          const Divider(height: 16),
                          _buildInfoRow('Airline', ticket['airline']),
                          const Divider(height: 16),
                          _buildInfoRow('Sector', ticket['sector']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplier',
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticket['supplier'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PKR ${NumberFormat('#,##0.00').format(ticket['buying'])}',
                              style: TextStyle(
                                color: TColor.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Text(
          'TOTAL From ${DateFormat('E, dd MMM yyyy').format(controller.startDate.value)} '
          'TO ${DateFormat('E, dd MMM yyyy').format(controller.endDate.value)} '
          'PKR ${NumberFormat('#,##0.00').format(controller.totalAmount)}',
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget _buildDateSelectors() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: TColor.white,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DateSelector2(
                label: 'From Month',
                fontSize: 12,
                initialDate: DateTime.now(),
                selectMonthOnly: true,
                onDateChanged: print,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DateSelector2(
                label: 'To Month',
                fontSize: 12,
                initialDate: DateTime.now(),
                selectMonthOnly: true,
                onDateChanged: print,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'From ${DateFormat('MMM yyyy').format(DateTime.now())} To ${DateFormat('MMM yyyy').format(DateTime.now())}',
          style: TextStyle(
            color: TColor.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
