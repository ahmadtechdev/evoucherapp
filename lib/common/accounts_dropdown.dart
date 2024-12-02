import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widget/custom_dropdown.dart';
import '../views/accounts/accounts/account_controller.dart';


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
      final accountNames = accountsList.map((account) => account.name).toList();

      return CustomDropdown(
        hint: 'Select an account',
        items: accountNames,
        selectedItem: initialValue?.isEmpty ?? true ? null : initialValue,
        onChanged: onChanged,
        enabled: isEnabled,
      );
    });
  }
}