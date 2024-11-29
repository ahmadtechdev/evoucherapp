import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/drawer.dart';
import '../../../common_widget/round_textfield.dart';
import 'accounts_modal_class.dart';
import 'account_controller.dart';
import '../accounts_ledger/view_accounts_ledger.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the AccountsController
    final AccountsController accountsController = Get.put(AccountsController());

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Accounts'),
      ),
      drawer: const CustomDrawer(currentIndex: 3),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchTextField(
              hintText: 'Search Accounts...',
              controller: TextEditingController(),
              onChange: (query) {
                accountsController.searchAccounts(query);
              },
            ),
          ),
          Obx(() {
            // Show loading indicator while fetching accounts
            if (accountsController.isLoading.value) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Check if filtered accounts is empty
            if (accountsController.filteredAccounts.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No accounts found',
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            // Display the list of accounts
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: accountsController.filteredAccounts.length,
                itemBuilder: (context, index) {
                  final account = accountsController.filteredAccounts[index];
                  return _buildAccountCard(context, account);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountModel account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(
          color: TColor.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Name and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.name,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TColor.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "ID: ${account.id}",
                    style: TextStyle(
                      color: TColor.secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Account Contact
            Text(
              account.contact,
              style: TextStyle(
                color: TColor.third,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Sub Head
            Row(
              children: [
                Text(
                  'Sub Head: ',
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
                Text(
                  account.subHead,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => LedgerScreen(
                      accountId: account.id,
                      accountName: account.name,
                    ));
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Ledger button logic
                  },
                  icon: const Icon(Icons.book, size: 18),
                  label: const Text('Ledger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Added By
            Text(
              'Added by: ${account.addedBy}',
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}