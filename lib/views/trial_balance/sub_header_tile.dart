import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../common/color_extension.dart';
import 'account_types_tile.dart';
import 'modal.dart';

class SubHeaderExpansionTile extends StatelessWidget {
  final AccountSubHeader subHeader;

  const SubHeaderExpansionTile({
    super.key,
    required this.subHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(MdiIcons.shieldCrown, color: TColor.third),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add, color: TColor.third),
              onPressed: () {
                // Add your onPressed functionality here
              },
            ),
            // This is the default expansion arrow icon
            const RotationTransition(
              turns: AlwaysStoppedAnimation(0.0),
              child: Icon(Icons.expand_more),
            ),
          ],
        ),
        title: Text(
          subHeader.name,
          style: TextStyle(
            color: TColor.third,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Added by: ${subHeader.addedBy}',
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 12,
          ),
        ),
        children: [
          ...subHeader.accountTypes.map((type) => AccountTypeExpansionTile(accountType: type)),
        ],
      ),
    );
  }
}
