import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../common/color_extension.dart';
import 'account_types_tile.dart';
import '../models/modal.dart';

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
      child: subHeader.accountTypes.isNotEmpty
          ? ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(MdiIcons.shieldCrown, color: TColor.third),
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
        children: subHeader.accountTypes
            .map((type) => AccountTypeExpansionTile(accountType: type))
            .toList(),
      )
          : ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(MdiIcons.shieldCrown, color: TColor.third),
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
        // trailing: Icon(
        //   Icons.hourglass_empty, // Replace with any icon you prefer
        //   color: TColor.secondaryText, // Makes the icon invisible
        // ),
      ),
    );
  }
}