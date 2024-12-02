import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/round_textfield.dart';
import 'accounts_modal_class.dart';
import 'account_controller.dart';
import '../accounts_ledger/view_accounts_ledger.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the AccountsController
    final AccountsController accountsController = Get.find<AccountsController>();
    // final AccountsController accountsController = Get.put(AccountsController());
    // accountsController = Get.find<AccountsController>();

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Accounts'),
      ),
      drawer: const CustomDrawer(currentIndex: 1),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Name and ID
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.8,
                    child: Text(
                      account.name,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Allows the text to go to a second line
                      overflow: TextOverflow.visible, // Ensures overflow content is displayed
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
            ),
            const SizedBox(height: 8),
            // Account Contact

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Added by: ${account.addedBy}',
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => LedgerScreen(
                      accountId: account.id,
                      accountName: account.name,
                    ));
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

          ],
        ),
      ),
    );
  }
}