import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/color_extension.dart';
import 'accounts_tile.dart';
import '../models/modal.dart';

class AccountTypeExpansionTile extends StatelessWidget {
  final AccountType accountType;

  const AccountTypeExpansionTile({
    super.key,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(MdiIcons.shieldCrownOutline, color: TColor.primary),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Icon(Icons.add, color: TColor.primary),
            //   onPressed: () {
            //     // Add your onPressed functionality here
            //   },
            // ),
            // This is the default expansion arrow icon
            RotationTransition(
              turns: AlwaysStoppedAnimation(0.0),
              child: Icon(Icons.expand_more),
            ),
          ],
        ),
        title: Text(
          accountType.typeName,
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: accountType.accounts
                  .map((account) => AccountCard(account: account))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}