import 'package:evoucher_new/views/side_bar/manage_user/manage_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/session_manager.dart';
import '../views/home/home.dart';
import '../views/side_bar/accounts/accounts/accounts.dart';
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
import '../views/side_bar/top_agent_report/top_agent_sale.dart';
import '../views/side_bar/top_customer_sale/top_customer_sale.dart';
import '../views/side_bar/top_suuplier_report/top_supplier_sale.dart';
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
  String? loginType;
  Map<String, dynamic>? userAccess;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
    _initializeLoginType();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedItem();
    });
  }

  Future<void> _initializeLoginType() async {
    final sessionManager = Get.find<SessionManager>();
    loginType = await sessionManager.getLoginType();
    userAccess = await sessionManager.getUserAccess();
    print("check");
    print(userAccess);
    setState(() {});
  }

  // Add method to check access
  bool _hasAccess(String moduleKey) {
    return userAccess?.containsKey(moduleKey) ?? false;
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
      final RenderObject? renderObject =
          _selectedItemKey.currentContext!.findRenderObject();
      if (renderObject != null) {
        final ScrollableState scrollableState =
            Scrollable.of(_selectedItemKey.currentContext!);
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
        key: isSelected ? _selectedItemKey : null,
        // Add key to selected item
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
      height: 120,
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
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'Unknown',
            //       style: TextStyle(color: TColor.white, fontSize: 16),
            //     ),
            //     Text(
            //       'Agency ID: Unknown',
            //       style: TextStyle(color: Colors.grey[400], fontSize: 14),
            //     ),
            //     Text(
            //       // 'Expires On: Wed 13 Aug 2025',
            //       'Expires On: Unknown',
            //       style: TextStyle(color: Colors.grey[400], fontSize: 12),
            //     ),
            //     Text(
            //       // 'Cash: 39,801.00 Cr',
            //       'Cash: Unknown',
            //       style: TextStyle(color: Colors.grey[400], fontSize: 12),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
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

    // Always show Home (no access check needed)
    items.add(_buildNavigationItem(
      title: 'Home',
      icon: Icons.dashboard_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const Home()),
    ));

    // Check if user has any accounts-related access
    bool hasAccountsSection = _hasAccess('1AB') || _hasAccess('13DATA'); // chartofaccounts or viewaccounts

    if (hasAccountsSection) {
      items.add(_buildSectionHeader(
        title: 'ACCOUNTS',
        icon: Icons.account_balance_wallet_rounded,
      ));

      if (_hasAccess('1AB') || _hasAccess('13DATA')) { // chartofaccounts or viewaccounts
        items.add(_buildNavigationItem(
          title: 'Accounts',
          icon: Icons.person,
          index: currentIndex++,
          onTap: () => Get.to(() => const Accounts()),
        ));
      }
    }

    // Invoice Settlement
    items.add(_buildNavigationItem(
      title: 'Invoice Settlement',
      icon: Icons.receipt_long_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const InvoiceSettlement()),
    ));

    if (_hasAccess('2AS')) { // dailycashbook
      items.add(_buildNavigationItem(
        title: 'Daily Cash Book',
        icon: Icons.menu_book_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => DailyCashBook()),
      ));
    }

    if (_hasAccess('24DAR')) { // dailyactivityreport
      items.add(_buildNavigationItem(
        title: 'Daily Activity Report',
        icon: Icons.calendar_today_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => DailyActivityReport()),
      ));
    }

    // Daily Cash Activity
    items.add(_buildNavigationItem(
      title: 'Daily Cash Activity',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const DailyCashActivity()),
    ));

    // Monthly Sale Report
    items.add(_buildNavigationItem(
      title: 'Monthly Sale Report',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => MonthlySalesReport()),
    ));

    // Expenses Report
    items.add(_buildNavigationItem(
      title: 'Expenses Report',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => ExpenseComparisonReport()),
    ));

    // Incomes Report
    items.add(_buildNavigationItem(
      title: 'Incomes Report',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const IncomesComparisonReport()),
    ));

    // Daily Sales Report
    items.add(_buildNavigationItem(
      title: 'Daily Sales Report',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const DailySalesReportScreen()),
    ));

    // Recovery List
    items.add(_buildNavigationItem(
      title: 'Recovery List',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => RecoveryListsScreen()),
    ));

    // Financial Reports Section
    bool hasFinancialReports = _hasAccess('14GSK') || _hasAccess('17PL'); // trialbalance or profitloss

    if (hasFinancialReports) {
      items.add(_buildSectionHeader(
        title: 'FINANCIAL REPORTS',
        icon: Icons.analytics_rounded,
      ));

      if (_hasAccess('14GSK')) { // trialbalance
        items.add(_buildNavigationItem(
          title: 'Trial Balance',
          icon: Icons.analytics_rounded,
          index: currentIndex++,
          onTap: () => Get.to(() => TrialOfBalanceScreen()),
        ));
      }

      if (_hasAccess('17PL')) { // profitloss
        items.add(_buildNavigationItem(
          title: 'Monthly Profit Loss',
          icon: Icons.analytics_rounded,
          index: currentIndex++,
          onTap: () => Get.to(() => MonthlyProfitLoss()),
        ));
      }
    }

    // Customer and Other Reports
    if (_hasAccess('18CSTRPT')) { // customerreports
      items.add(_buildNavigationItem(
        title: 'Top Customers Sales',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => CustomerReportScreen()),
      ));
    }

    // 5 Year Customer Sales
    items.add(_buildNavigationItem(
      title: '5 Year Customers Sales',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => const FiveYearsCustomerSale()),
    ));

    // Top Supplier Report
    items.add(_buildNavigationItem(
      title: 'Top Supplier Report',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => SupplierReportScreen()),
    ));

    if (_hasAccess('20AGTRPT')) { // subagentreports
      items.add(_buildNavigationItem(
        title: 'Top Agent Sales',
        icon: Icons.analytics_rounded,
        index: currentIndex++,
        onTap: () => Get.to(() => AgentReportScreen()),
      ));
    }

    // Manage User
    items.add(_buildNavigationItem(
      title: 'Manage User',
      icon: Icons.analytics_rounded,
      index: currentIndex++,
      onTap: () => Get.to(() => ManageUser()),
    ));

    return items;
  }

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
