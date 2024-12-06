import 'package:evoucher/views/accounts/accounts/accounts.dart';
import 'package:evoucher/views/home/home.dart';
import 'package:evoucher/views/invoice_settlement/invoice_settlement/invoice_settlement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/daily_acitvity_report/daily_activity_report.dart';
import '../views/daily_cash_activity/daily_cash_activity.dart';
import '../views/daily_cash_book/daily_cash_book.dart';
import '../views/daily_sales_report/daily_sales_report.dart';
import '../views/expense_report/expense_report.dart';
import '../views/incomes_report/income_report_view.dart';
import '../views/monthly_sale_report/monthly_sale_report.dart';
import '../views/recovery_list/recovery_list.dart';
import '../views/5_year_customers_sales/5_year_customers_sale.dart';
import '../views/top_customer_sale/top_customer_sale.dart';
import '../views/trial_balance/trial_balance.dart';
import 'color_extension.dart';

class CustomDrawer extends StatefulWidget {
  final int currentIndex;

  const CustomDrawer({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        selectedIndex = widget.currentIndex;
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 180,
      child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.black87),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/img/newLogo.png',
                    fit: BoxFit.cover,
                    scale: 3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Umer Liaqat Admin',
                  style: TextStyle(color: TColor.white, fontSize: 16),
                ),
                Text(
                  'Agency ID: 157',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                Text(
                  'Expires On: Wed 13 Aug 2025',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  'Cash: 39,801.00 Cr',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
  }) {
    return Container(
      color: TColor.secondary,
      child: ListTile(
        dense: true,
        enabled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: TColor.white,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: TColor.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required IconData icon,
    required int index,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: isSelected ? TColor.primary : (iconColor ?? Colors.black87),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? TColor.primary : (textColor ?? Colors.black87),
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          onTap?.call();
        },
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    int currentIndex = 0;
    final List<Widget> items = [];

    // Home Section
    items.add(_buildNavigationItem(
      title: 'Home',
      icon: Icons.dashboard_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const Home()),
    ));

    // Accounts Section
    items.add(_buildSectionHeader(
      title: 'ACCOUNTS',
      icon: Icons.account_balance_wallet_rounded,
    ));

    items.add(_buildNavigationItem(
      title: 'Accounts',
      icon: Icons.person,
      index: currentIndex++,
      onTap: () => Get.to(() => const Accounts()),
    ));

    // Reports Section
    items.addAll([
      _buildNavigationItem(
        title: 'Invoice Settlement',
        icon: Icons.receipt_long_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => const InvoiceSettlement()),
      ),
      _buildNavigationItem(
        title: 'Daily Cash Book',
        icon: Icons.menu_book_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => DailyCashBook()),
      ),
      _buildNavigationItem(
        title: 'Daily Activity Report',
        icon: Icons.calendar_today_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => DailyActivityReport()),

      ),
      _buildNavigationItem(
        title: 'Daily Cash Activity',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() =>  DailyCashActivity()),
      ),
      _buildNavigationItem(
        title: 'Monthly Sale Report',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => MonthlySalesReport()),

      ),   _buildNavigationItem(
        title: 'Expenses Report',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() =>  ExpenseComparisonReport()),

      ), _buildNavigationItem(
        title: 'Incomes Report',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => const IncomesComparisonReport()),

      ), _buildNavigationItem(
        title: 'Daily Sales Report',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => const DailySalesReportScreen()),

      ),_buildNavigationItem(
        title: 'Recovery List',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => RecoveryListsScreen()),

      ),
    ]);



    // Financial Reports Section
    items.add(_buildSectionHeader(
      title: 'FINANCIAL REPORTS',
      icon: Icons.analytics_rounded,
    ));

    items.addAll([
      _buildNavigationItem(
        title: 'Trial Balance',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => TrialOfBalanceScreen()),

      ),
    ]);
    final financialReports = [

      'Monthly Profit Loss',
      'Total Monthly Profit Loss',
      'Total Expenses Report',
    ];

    items.addAll(
      financialReports.map((title) => _buildNavigationItem(
            title: title,
            icon: Icons.analytics_rounded,
            index: currentIndex++,
          )),
    );
    items.addAll([
      _buildNavigationItem(
        title: 'Top Customers Sales',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => const CustomerReportScreen()),

      ),_buildNavigationItem(
        title: '5 Year Customers Sales',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => const FiveYearsCustomerSale()),

      ),
    ]);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(context),
            ..._buildDrawerItems(),
          ],
        ),
      ),
    );
  }
}
