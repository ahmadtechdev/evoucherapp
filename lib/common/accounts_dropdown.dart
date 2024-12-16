import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widget/custom_dropdown.dart';
import '../views/accounts/accounts/controller/account_controller.dart';

class AccountDropdown extends StatelessWidget {
  final Color primaryColor;
  final bool isEnabled;
  final String? initialValue;
  final void Function(String?)? onChanged;

  const AccountDropdown({
    super.key,
    this.primaryColor = const Color(0xFF2196F3),
    this.isEnabled = true,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AccountsController accountsController = Get.find<AccountsController>();

    return Obx(() {
      final accountsList = accountsController.accounts;

      // Create a map of account IDs to account names
      final accountsMap = {
        for (var account in accountsList)
          account.id.toString(): account.name
      };

      return CustomDropdown(
        hint: 'Select an account',
        items: accountsMap, // Pass the map instead of just names
        selectedItemId: initialValue, // Use selectedItemId with the account ID
        onChanged: (selectedAccountId) {
          // When an account is selected, the ID will be passed to the onChanged callback
          onChanged?.call(selectedAccountId);
        },
        enabled: isEnabled,
      );
    });
  }
}