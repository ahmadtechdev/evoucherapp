import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/drawer.dart';
import '../../../common_widget/round_textfield.dart';
import 'accounts_modal_class.dart';
import 'accounts_provider.dart';
import '../accounts_ledger/view_accounts_ledger.dart';

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<Accounts> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  final TextEditingController _searchController = TextEditingController();
  List<AccountModel> _filteredAccounts = [];

  void _searchAccounts(String query) {
    final accounts = ref.read(accountsDataProvider).value ?? [];
    setState(() {
      _filteredAccounts = accounts.where((account) {
        return account.name.toLowerCase().contains(query.toLowerCase()) ||
            account.contact.contains(query) ||
            account.subHead.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsyncValue = ref.watch(accountsDataProvider);

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
          SearchTextField(
            hintText: 'Search Accounts...',
            controller: _searchController,
            onChange: _searchAccounts,
          ),
          Expanded(
            child: accountsAsyncValue.when(
              data: (accounts) {
                // Initialize filtered accounts if empty
                if (_filteredAccounts.isEmpty) {
                  _filteredAccounts = accounts;
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredAccounts.length,
                  itemBuilder: (context, index) {
                    final account = _filteredAccounts[index];
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
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
                            Text(
                              account.contact,
                              style: TextStyle(
                                color: TColor.third,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.book, size: 18),
                                  label: const Text('Ledger'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColor.secondary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                  },
                );
              },
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}