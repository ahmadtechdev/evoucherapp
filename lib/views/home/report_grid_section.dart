import 'package:flutter/material.dart';

class ReportsGridSection extends StatelessWidget {
  final Function(String category, String report)? onReportTap;

  const ReportsGridSection({super.key, this.onReportTap});

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
                onTab: () {
                  print("Expenses Report tapped!");
                },
              ),
              ReportItem(
                "Income Report",
                Icons.trending_up,
                const Color(0xff37B45D),
                onTab: () {
                  print("Income Report tapped!");
                },
              ),
              ReportItem(
                "Monthly Profit Loss",
                Icons.assessment,
                const Color(0xffE64A19),
              ),
              ReportItem(
                "Daily Sales Report",
                Icons.point_of_sale,
                const Color(0xff0289ee),
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
                onTab: () {
                  print("Top Customer Sales tapped!");
                },
              ),
              ReportItem(
                "5 Year Customer Sales",
                Icons.timeline,
                const Color(0xff37B45D),
              ),
              ReportItem(
                "Top Suppliers Sales",
                Icons.business,
                const Color(0xffE64A19),
              ),
              ReportItem(
                "Top Agent Sales",
                Icons.person_outline,
                const Color(0xff0289ee),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (report.onTab != null) {
            report.onTab!();
          } else if (onReportTap != null) {
            onReportTap!(category, report.title);
          }
        },
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
                  style: const TextStyle(
                    color: Color(0xFF4A4B4D),
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: report.iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  report.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
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
  final VoidCallback? onTab;

  ReportItem(this.title, this.icon, this.iconColor, {this.onTab});
}
