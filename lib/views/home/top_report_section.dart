import 'package:evoucher_new/views/home/top_report_section_views/agent_report/agent_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/airline_report/airline_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/bank_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bsp_report/bsp_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/customer_report/customer_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/visa_hotel_report/visa_hotel_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';

class ReportSection extends StatelessWidget {
  const ReportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _dashboardItem(
                  Icons.people,
                  'CUSTOMERS',
                  'Report',
                  () {
                    Get.to(() => CustomerTransactionScreen());
                    // Handle onTap for CUSTOMERS
                  },
                ),
                _dashboardItem(
                  Icons.account_balance,
                  'BANKS',
                  'Report',
                  () {
                    // Handle onTap for BANKS
                    Get.to(() => BanksScreen());
                  },
                ),
                _dashboardItem(
                  Icons.person,
                  'AGENTS',
                  'Report',
                  () {
                    // Handle onTap for AGENTS
                    Get.to(() => AgentReport());
                  },
                ),
                _dashboardItem(
                  Icons.flight,
                  'AIRLINES',
                  'Report',
                  () {
                    // Handle onTap for AIRLINES
                    Get.to(() => AirlineReport());
                  },
                ),
                _dashboardItem(
                  Icons.hotel,
                  'VISA HOTEL',
                  'Report',
                  () {
                    // Handle onTap for VISA HOTEL
                    Get.to(() => VisaHotelReport());
                  },
                ),
                _dashboardItem(
                  Icons.analytics,
                  'BSP',
                  'Report',
                  () {
                    // Handle onTap for BSP
                    Get.to(() => TicketListingScreen());
                  },
                ),
                _dashboardItem(
                  Icons.calculate,
                  'TRIAL BALANCE',
                  'Report',
                  () {
                    // Handle onTap for TRIAL BALANCE
                    print('TRIAL BALANCE Report tapped');
                  },
                ),
                _dashboardItem(
                  Icons.star,
                  'TOP CUSTOMERS',
                  'Report',
                  () {
                    // Handle onTap for TOP CUSTOMERS
                    print('TOP CUSTOMERS Report tapped');
                  },
                ),
                _dashboardItem(
                  Icons.trending_up,
                  'TOP SUPPLIER',
                  'Report',
                  () {
                    // Handle onTap for TOP SUPPLIER
                    print('TOP SUPPLIER Report tapped');
                  },
                ),
                _dashboardItem(
                  Icons.group,
                  'TOP AGENTS',
                  'Report',
                  () {
                    // Handle onTap for TOP AGENTS
                    print('TOP AGENTS Report tapped');
                  },
                ),
                _dashboardItem(
                  Icons.calendar_today,
                  'DAY WISE',
                  'Sales Report',
                  () {
                    // Handle onTap for DAY WISE SALES
                    print('DAY WISE Sales Report tapped');
                  },
                ),
                _dashboardItem(
                  Icons.bar_chart,
                  'YEARLY SALES',
                  'Report',
                  () {
                    // Handle onTap for YEARLY SALES
                    print('YEARLY SALES Report tapped');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dashboardItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Add the onTap callback here
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green[100],
              child: Icon(
                icon,
                size: 25,
                color: TColor.secondary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
