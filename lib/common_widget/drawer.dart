import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0;

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required int index,
    Color? textColor,
    Color? iconColor,
    Color? tileColor,
    VoidCallback? onTap,
  }) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true, // Makes the ListTile slightly smaller
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: isSelected ? TColor.white : iconColor,
          size: 22, // Slightly smaller icons
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? TColor.white : textColor,
            fontSize: 14, // Slightly smaller text
          ),
        ),
        selected: isSelected,
        selectedTileColor: TColor.primary,
        tileColor: tileColor,
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
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight / 3.6,
        child: DrawerHeader(
          decoration: const BoxDecoration(color: Colors.black87),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: TColor.white,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img/shorLogo.png',
                      fit: BoxFit.cover,
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Umer Liaqat Admin',
                  style: TextStyle(color: TColor.white, fontSize: 16),
                ),
                Text(
                  'Agency Id: 157',
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildListTile(
            title: 'Add New Branch',
            icon: Icons.add,
            index: -1,
          ),
          _buildListTile(
            title: 'Home',
            icon: Icons.dashboard_rounded,
            index: 0,
            onTap: () => Navigator.pop(context),
          ),
          _buildListTile(
            title: 'ACCOUNTS',
            icon: Icons.account_balance_wallet_rounded,
            index: 1,
            textColor: TColor.white,
            tileColor: TColor.secondary,
            iconColor: TColor.white
          ),
          _buildListTile(
            title: 'Chart of Accounts',
            icon: Icons.account_balance_rounded,
            index: 2,
          ),
          _buildListTile(
            title: 'Foreign Accounts',
            icon: Icons.public_rounded,
            index: 3,
          ),
          _buildListTile(
            title: 'All Inv Aging Report',
            icon: Icons.assessment_rounded,
            index: 4,
          ),
          _buildListTile(
            title: 'Invoice Settlement',
            icon: Icons.receipt_long_rounded,
            index: 5,
          ),
          _buildListTile(
            title: 'Daily Cash Book',
            icon: Icons.menu_book_rounded,
            index: 6,
          ),
          _buildListTile(
            title: 'Daily Activity Report',
            icon: Icons.calendar_today_rounded,
            index: 7,
          ),
          _buildListTile(
            title: 'System Activity Report',
            icon: Icons.history_rounded,
            index: 8,
            textColor: TColor.third,
            iconColor: TColor.third,
          ),
          _buildListTile(
            title: 'Daily Cash Activity',
            icon: Icons.account_balance_wallet_rounded,
            index: 9,
          ),
          _buildListTile(
            title: 'Roznamcha',
            icon: Icons.article_rounded,
            index: 10,
          ),
          _buildListTile(
            title: 'Expenses Report',
            icon: Icons.trending_down_rounded,
            index: 11,
          ),
          _buildListTile(
            title: 'Incomes Report',
            icon: Icons.trending_up_rounded,
            index: 12,
          ),
          _buildListTile(
            title: 'Total Income Report',
            icon: Icons.show_chart_rounded,
            index: 13,
          ),
          _buildListTile(
            title: 'Daily Sales Report',
            icon: Icons.point_of_sale_rounded,
            index: 14,
          ),
          _buildListTile(
            title: 'Recovery List',
            icon: Icons.restore_rounded,
            index: 15,
          ),
          _buildListTile(
            title: 'FINANCIAL REPORTS',
            icon: Icons.analytics_rounded,
            index: 16,
            textColor: TColor.white,
            tileColor: TColor.secondary,
            iconColor: TColor.white
          ),
          // Financial Reports Section
          ...[
            'Balance Sheet',
            'Trial Balance',
            'Detailed Trial Balance',
            'Categorized Trial Balance',
          ].asMap().entries.map((entry) => _buildListTile(
            title: entry.value,
            icon: Icons.table_chart_rounded,
            index: 17 + entry.key,
          )),
          ...[
            'Month Wise Segment Report',
            'Monthly Profit Loss',
            'Total Monthly Profit Loss',
          ].asMap().entries.map((entry) => _buildListTile(
            title: entry.value,
            icon: Icons.analytics_rounded,
            index: 21 + entry.key,
          )),
          _buildListTile(
            title: 'Total Expenses Report',
            icon: Icons.receipt_long_rounded,
            index: 24,
          ),
          _buildListTile(
            title: 'Foreign Trial Balance',
            icon: Icons.table_chart_rounded,
            index: 25,
          ),
          // Sales Reports with third color
          ...[
            'Total Sale Report',
            'Top Customers Sales',
            '5 Year Customers Sales',
            'Top Supplier Report',
            'Top Agent Sales',
            'Top Airlines Sales',
          ].asMap().entries.map((entry) => _buildListTile(
            title: entry.value,
            icon: Icons.trending_up_rounded,
            index: 26 + entry.key,
            textColor: TColor.third,
            iconColor: TColor.third,
          )),
          ExpansionTile(
            leading: const Icon(Icons.close_fullscreen_rounded),
            title: const Text('Closings'),
            textColor: Colors.green,
            iconColor: Colors.green,
            children: [
              _buildListTile(
                title: 'Entry Closing',
                icon: Icons.radio_button_unchecked_rounded,
                index: 32,
              ),
              _buildListTile(
                title: 'View Closing',
                icon: Icons.radio_button_unchecked_rounded,
                index: 33,
              ),
            ],
          ),
          _buildListTile(
            title: 'Void Report',
            icon: Icons.history_rounded,
            index: 34,
          ),

          _buildListTile(
            title: 'ADMIN',
            icon: Icons.admin_panel_settings_rounded,
            index: 35,
            textColor: TColor.white,
            tileColor: TColor.secondary,
            iconColor: TColor.white
          ),
          // Admin section
          ...[
            {'title': 'Reconcile Vouchers', 'icon': Icons.receipt_rounded},
            {'title': 'Airlines', 'icon': Icons.flight_rounded},
            {'title': 'Add Hotels', 'icon': Icons.hotel_rounded},
            {'title': 'Add Shirka', 'icon': Icons.business_rounded},
            {'title': 'Add Consultant', 'icon': Icons.person_add_rounded},
            {'title': 'Manage Users', 'icon': Icons.group_rounded},
            {'title': 'Create User', 'icon': Icons.person_add_alt_rounded},
            {'title': 'Password', 'icon': Icons.key_rounded},
            {'title': 'Company Profile', 'icon': Icons.business_center_rounded},
            {'title': 'Log Activity', 'icon': Icons.history_rounded},
            {'title': 'BACKUP', 'icon': Icons.backup_rounded},
          ].asMap().entries.map((entry) => _buildListTile(
            title: entry.value['title'].toString(),
            icon: entry.value['icon'] as IconData,
            index: 36 + entry.key,
          )),
        ],
      ),
    );
  }
}