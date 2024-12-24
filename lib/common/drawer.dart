import 'package:evoucher/views/side_bar/accounts/accounts/accounts.dart';
import 'package:evoucher/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/side_bar/daily_acitvity_report/daily_activity_report.dart';
import '../views/side_bar/daily_cash_activity/daily_cash_activity.dart';
import '../views/side_bar/daily_cash_book/daily_cash_book.dart';
import '../views/side_bar/daily_sales_report/daily_sales_report.dart';
import '../views/side_bar/expense_report/expense_report.dart';
import '../views/side_bar/incomes_report/income_report_view.dart';
import '../views/side_bar/invoice_settlement/invoice_settlement/invoice_settlement.dart';
import '../views/side_bar/monthly_profit_loss/monthly_profit_loss.dart';
import '../views/side_bar/monthly_sale_report/monthly_sale_report.dart';
import '../views/side_bar/5_year_customers_sales/five_year_customers_sale.dart';
import '../views/side_bar/recovery_list/recovery_list.dart';
import '../views/side_bar/top_customer_sale/top_customer_sale.dart';
import '../views/side_bar/total_monthly_expense/total_monthly_expenses.dart';
import '../views/side_bar/total_monthly_profit_loss/total_monthly_profit_loss.dart';
import '../views/side_bar/trial_balance/trial_balance.dart';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _selectedItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
    // Schedule a post-frame callback to scroll to the selected item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedItem();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        selectedIndex = widget.currentIndex;
      });
      // Scroll to newly selected item when currentIndex changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedItemKey.currentContext != null) {
      final RenderObject? renderObject = _selectedItemKey.currentContext!.findRenderObject();
      if (renderObject != null) {
        final ScrollableState scrollableState = Scrollable.of(_selectedItemKey.currentContext!);
        scrollableState.position.ensureVisible(
          renderObject,
          alignment: 0.5, // Center the item
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
            }
    }
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
        key: isSelected ? _selectedItemKey : null, // Add key to selected item
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
        onTap: () => Get.to(() =>  const DailyCashActivity()),
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

      ), _buildNavigationItem(
        title: 'Monthly Profit Loss',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => MonthlyProfitLoss()),

      ), _buildNavigationItem(
        title: 'Total Monthly Profit Loss',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => TotalMonthlyProfitLoss()),

      ),_buildNavigationItem(
        title: 'Total Expenses Report',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => TotalMonthlyExpenses()),

      ),
    ]);

    items.addAll([
      _buildNavigationItem(
        title: 'Top Customers Sales',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => CustomerReportScreen()),

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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: ListView(
          controller: _scrollController,
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


