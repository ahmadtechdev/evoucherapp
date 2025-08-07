import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/snackbar.dart';
import '../../service/session_manager.dart';
import '../side_bar/5_year_customers_sales/five_year_customers_sale.dart';
import '../side_bar/daily_sales_report/daily_sales_report.dart';
import '../side_bar/expense_report/expense_report.dart';
import '../side_bar/incomes_report/income_report_view.dart';
import '../side_bar/monthly_sale_report/monthly_sale_report.dart';
import '../side_bar/top_agent_report/top_agent_sale.dart';
import '../side_bar/top_customer_sale/top_customer_sale.dart';
import '../side_bar/top_suuplier_report/top_supplier_sale.dart';

class ReportsGridSection extends StatefulWidget {
  final Function(String category, String report)? onReportTap;

  const ReportsGridSection({super.key, this.onReportTap});

  @override
  State<ReportsGridSection> createState() => _ReportsGridSectionState();
}

class _ReportsGridSectionState extends State<ReportsGridSection> {
  String? loginType;
  Map<String, dynamic>? userAccess;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final sessionManager = Get.find<SessionManager>();
    loginType = await sessionManager.getLoginType();
    userAccess = await sessionManager.getUserAccess();
    setState(() {});
  }

  bool _hasAccess(String moduleKey) {
    return userAccess?.containsKey(moduleKey) ?? false;
  }

  void _showAccessDeniedMessage() {
    CustomSnackBar(
      message: "You don't have access to this module",
      backgroundColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildReportCategory(
            "Financial Report",
            [
              ReportItem(
                "Expenses Report",
                Icons.receipt_long,
                const Color(0xff0289ee),
                accessKey: null, // No specific access key, always show
                onTap: () => Get.to(() => ExpenseComparisonReport()),
              ),
              ReportItem(
                "Income Report",
                Icons.trending_up,
                const Color(0xff37B45D),
                accessKey: null, // No specific access key, always show
                onTap: () => Get.to(() => const IncomesComparisonReport()),
              ),
              ReportItem(
                "Monthly Profit Loss",
                Icons.assessment,
                const Color(0xffE64A19),
                accessKey: "17PL", // profitloss
                onTap: () => Get.to(() => MonthlySalesReport()),
              ),
              ReportItem(
                "Daily Sales Report",
                Icons.point_of_sale,
                const Color(0xff0289ee),
                accessKey: null, // No specific access key, always show
                onTap: () => Get.to(() => const DailySalesReportScreen()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReportCategory(
            "Sales Report",
            [
              ReportItem(
                "Top Customer Sales",
                Icons.people,
                const Color(0xff0289ee),
                accessKey: "18CSTRPT", // customerreports
                onTap: () => Get.to(() => CustomerReportScreen()),
              ),
              ReportItem(
                "5 Year Customer Sales",
                Icons.timeline,
                const Color(0xff37B45D),
                accessKey: null, // No specific access key, always show
                onTap: () => Get.to(() => const FiveYearsCustomerSale()),
              ),
              ReportItem(
                "Top Suppliers Sales",
                Icons.business,
                const Color(0xffE64A19),
                accessKey: null, // No specific access key, always show
                onTap: () => Get.to(() => SupplierReportScreen()),
              ),
              ReportItem(
                "Top Agent Sales",
                Icons.person_outline,
                const Color(0xff0289ee),
                accessKey: "20AGTRPT", // subagentreports
                onTap: () => Get.to(() => AgentReportScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCategory(String title, List<ReportItem> reports) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xff37B45D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              return _buildReportItem(title, reports[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String category, ReportItem report) {
    final bool hasAccess = report.accessKey == null || _hasAccess(report.accessKey!);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasAccess
            ? () {
          if (report.onTap != null) {
            report.onTap!();
          } else if (widget.onReportTap != null) {
            widget.onReportTap!(category, report.title);
          }
        }
            : _showAccessDeniedMessage,
        child: Opacity(
          opacity: hasAccess ? 1.0 : 0.5, // Dim the item if no access
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEEEEEE),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    report.title,
                    style: TextStyle(
                      color: hasAccess
                          ? const Color(0xFF4A4B4D)
                          : const Color(0xFF4A4B4D).withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasAccess
                        ? report.iconColor
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    hasAccess ? report.icon : Icons.lock,
                    color: Colors.white,
                    size: 20,
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

class ReportItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String? accessKey; // Add access key property
  final VoidCallback? onTap;

  ReportItem(
      this.title,
      this.icon,
      this.iconColor,
      {
        this.accessKey, // Add accessKey parameter
        this.onTap,
      }
      );
}