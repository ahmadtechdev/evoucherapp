import 'package:evoucher_new/views/home/top_report_section_views/agent_report/agent_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/airline_report/airline_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bank_report/bank_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/bsp_report/bsp_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/customer_report/customer_report.dart';
import 'package:evoucher_new/views/home/top_report_section_views/visa_hotel_report/visa_hotel_report.dart';
import 'package:evoucher_new/views/side_bar/accounts/accounts/accounts.dart';
import 'package:evoucher_new/views/side_bar/top_agent_report/top_agent_sale.dart';
import 'package:evoucher_new/views/side_bar/top_customer_sale/top_customer_sale.dart';
import 'package:evoucher_new/views/side_bar/top_suuplier_report/top_supplier_sale.dart';
import 'package:evoucher_new/views/side_bar/trial_balance/trial_balance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../service/session_manager.dart';
import 'top_report_section_views/details_sale_report/details_sale_report.dart';

class ReportSection extends StatefulWidget {
  const ReportSection({super.key});

  @override
  State<ReportSection> createState() => _ReportSectionState();
}

class _ReportSectionState extends State<ReportSection> {
  String? loginType;
  Map<String, dynamic>? userAccess;

  @override
  void initState() {
    super.initState();
    _initializeLoginTypeAndAccess();
  }

  Future<void> _initializeLoginTypeAndAccess() async {
    final sessionManager = Get.find<SessionManager>();
    loginType = await sessionManager.getLoginType();
    userAccess = await sessionManager.getUserAccess();
    setState(() {});
  }

  // Check if user has access to a specific module
  bool _hasAccess(String moduleKey) {
    return userAccess?.containsKey(moduleKey) ?? false;
  }

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
                if (_hasAccess('13DATA')) // viewaccounts
                  _dashboardItem(
                    Icons.person,
                    'LEDGER',
                    'Report',
                        () {
                      Get.to(() => const Accounts());
                    },
                  ),

                if (_hasAccess('18CSTRPT')) // customerreports
                  _dashboardItem(
                    Icons.people,
                    'CUSTOMERS',
                    'Report',
                        () {
                      Get.to(() => CustomerTransactionScreen());
                    },
                  ),

                if (_hasAccess('19BNKRPT')) // bankreports
                  _dashboardItem(
                    Icons.account_balance,
                    'BANKS',
                    'Report',
                        () {
                      Get.to(() => BanksScreen());
                    },
                  ),

                if (_hasAccess('20AGTRPT')) // subagentreports
                  _dashboardItem(
                    Icons.person,
                    'AGENTS',
                    'Report',
                        () {
                      Get.to(() => AgentReport());
                    },
                  ),

                if (_hasAccess('21ARLRPT')) // airlinereports
                  _dashboardItem(
                    Icons.flight,
                    'AIRLINES',
                    'Report',
                        () {
                      Get.to(() => AirlineReport());
                    },
                  ),

                if (_hasAccess('25VHS')) // visahotelreports
                  _dashboardItem(
                    Icons.hotel,
                    'VISA HOTEL',
                    'Report',
                        () {
                      Get.to(() => VisaHotelReport());
                    },
                  ),

                if (_hasAccess('22BSP')) // bspreports
                  _dashboardItem(
                    Icons.analytics,
                    'BSP',
                    'Report',
                        () {
                      Get.to(() => TicketListingScreen());
                    },
                  ),

                if (_hasAccess('14GSK')) // trialbalance
                  _dashboardItem(
                    Icons.calculate,
                    'TRIAL BALANCE',
                    'Report',
                        () {
                      Get.to(() => TrialOfBalanceScreen());
                    },
                  ),

                if (loginType == 'travel') ...[
                  if (_hasAccess('18CSTRPT')) // customerreports
                    _dashboardItem(
                      Icons.star,
                      'TOP CUSTOMERS',
                      'Report',
                          () {
                        Get.to(() => CustomerReportScreen());
                      },
                    ),

                  _dashboardItem(
                    Icons.trending_up,
                    'TOP SUPPLIER',
                    'Report',
                        () {
                      Get.to(() => SupplierReportScreen());
                    },
                  ),

                  if (_hasAccess('20AGTRPT')) // subagentreports
                    _dashboardItem(
                      Icons.group,
                      'TOP AGENTS',
                      'Report',
                          () {
                        Get.to(() => AgentReportScreen());
                      },
                    ),
                ],

                _dashboardItem(
                  Icons.calendar_today,
                  'DAY WISE',
                  'Sales Report',
                      () {
                    Get.to(() => const DetailsSaleReport());
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
      onTap: onTap,
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