import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../common/color_extension.dart';
import 'charts_of_accounts.dart';
import 'modal.dart';
import 'sub_header_tile.dart';
import 'total_section.dart';

class AccountHeaderCard extends StatelessWidget {
  final AccountHeader header;

  const AccountHeaderCard({
    Key? key,
    required this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Icon(
              MdiIcons.pageLayoutHeader,
              color: TColor.secondary,
            ),
            const SizedBox(width: 12),
            Text(
              header.title,
              style: TextStyle(
                color: TColor.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        children: [
          ...header.subHeaders.map((subHeader) => SubHeaderExpansionTile(subHeader: subHeader)),
          TotalSection(
            totalDebit: header.totalDebit,
            totalCredit: header.totalCredit,
          ),
        ],
      ),
    );
  }

  IconData getHeaderIcon(String title) {
    switch (title.toLowerCase()) {
      case 'assets':
        return Icons.account_balance_wallet;
      case 'liabilities':
        return Icons.money_off;
      case 'income and expenses':
        return Icons.account_balance;
      case 'equity':
        return Icons.pie_chart;
      default:
        return Icons.article;
    }
  }
}