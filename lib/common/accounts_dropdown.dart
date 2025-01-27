import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common_widget/custom_dropdown.dart';
import '../views/side_bar/accounts/accounts/controller/account_controller.dart';

class AccountDropdown extends StatelessWidget {
  final Color primaryColor;
  final bool isEnabled;
  final String? initialValue;
  final String? subHeadName;
  final String? hintText;
  final bool showSearch;
  final bool fetchOnInit;
  final List<String>? excludeAccountIds; // New parameter for excluding accounts
  final void Function(String?)? onChanged;

  const AccountDropdown({
    super.key,
    this.primaryColor = const Color(0xFF2196F3),
    this.isEnabled = true,
    this.initialValue,
    this.subHeadName,
    this.onChanged,
    this.hintText = 'Select an account',
    this.showSearch = true,
    this.fetchOnInit = true,
    this.excludeAccountIds, // Optional list of account IDs to exclude
  });

  @override
  Widget build(BuildContext context) {
    final AccountsController accountsController = Get.find<AccountsController>();

    // Fetch accounts when widget is built, if subHeadName is provided and fetchOnInit is true
    if (fetchOnInit && subHeadName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        accountsController.fetchAccounts(subheadName: subHeadName);
      });
    }

    return Obx(() {
      // Check for error message
      if (accountsController.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Error: ${accountsController.errorMessage}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => accountsController.fetchAccounts(subheadName: subHeadName),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      // Check the loading state first
      if (accountsController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      }

      // Filter out excluded accounts
      final filteredAccounts = excludeAccountIds != null
          ? accountsController.accounts
          .where((account) => !excludeAccountIds!.contains(account.id.toString()))
          .toList()
          : accountsController.accounts;

      // If filtered accounts list is empty and not loading, show a placeholder
      if (filteredAccounts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.grey,
                size: 50,
              ),
              const SizedBox(height: 10),
              const Text(
                'No accounts available',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => accountsController.fetchAccounts(subheadName: subHeadName),
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Create a map of account IDs to account names for filtered accounts
      final accountsMap = {
        for (var account in filteredAccounts)
          account.id.toString(): account.name
      };

      return CustomDropdown(
        showSearch: showSearch,
        hint: hintText.toString(),
        items: accountsMap,
        selectedItemId: initialValue,
        onChanged: (selectedAccountId) {
          onChanged?.call(selectedAccountId);
        },
        enabled: isEnabled,
      );
    });
  }
}