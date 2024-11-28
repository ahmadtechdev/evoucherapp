import 'package:flutter/material.dart';

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
                _dashboardItem(Icons.people, 'CUSTOMERS', 'Report'),
                _dashboardItem(Icons.account_balance, 'BANKS', 'Report'),
                _dashboardItem(Icons.person, 'AGENTS', 'Report'),
                _dashboardItem(Icons.flight, 'AIRLINES', 'Report'),
                _dashboardItem(Icons.hotel, 'VISA HOTEL', 'Report'),
                _dashboardItem(Icons.analytics, 'BSP', 'Report'),
                _dashboardItem(Icons.calculate, 'TRIAL BALANCE', 'Report'),
                _dashboardItem(Icons.star, 'TOP CUSTOMERS', 'Report'),
                _dashboardItem(Icons.trending_up, 'TOP SUPPLIER', 'Report'),
                _dashboardItem(Icons.group, 'TOP AGENTS', 'Report'),
                _dashboardItem(Icons.calendar_today, 'DAY WISE', 'Sales Report'),
                _dashboardItem(Icons.bar_chart, 'YEARLY SALES', 'Report'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dashboardItem(IconData icon, String title, String subtitle) {
    return Padding(
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
    );
  }
}
