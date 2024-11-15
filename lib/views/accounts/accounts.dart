import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common_widget/drawer.dart';
import '../../common_widget/round_textfield.dart';
import 'view_accounts_ledger.dart';

class Account {
  final String id;
  final String name;
  final String contact;
  final String subHead;
  final String addedBy;

  Account({
    required this.id,
    required this.name,
    required this.contact,
    required this.subHead,
    required this.addedBy,
  });
}

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final TextEditingController _searchController = TextEditingController();
  List<Account> _filteredAccounts = [];

  // Dummy data
  final List<Account> _accounts = [
    Account(
      id: "539",
      name: "Adam",
      contact: "1234567890",
      subHead: "TRAVEL AGENTS",
      addedBy: "Umer Liaqat",
    ),
    Account(
      id: "540",
      name: "Adam1",
      contact: "12345678901",
      subHead: "TRAVEL AGENTS",
      addedBy: "Umer Liaqat",
    ),
    Account(
      id: "453",
      name: "Afaq EMP",
      contact: "03107852255",
      subHead: "Current Liabilities",
      addedBy: "Umer Liaqat Admin",
    ),
    Account(
      id: "431",
      name: "Afaq Travels",
      contact: "+92 3107852255",
      subHead: "Transport Suppliers",
      addedBy: "Umer Liaqat Admin",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredAccounts = _accounts;
  }

  void _searchAccounts(String query) {
    setState(() {
      _filteredAccounts = _accounts.where((account) {
        return account.name.toLowerCase().contains(query.toLowerCase()) ||
            account.contact.contains(query) ||
            account.subHead.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text(
          'Accounts',
        ),
      ),
      drawer: const CustomDrawer(currentIndex: 3),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: _searchAccounts,
          //     decoration: InputDecoration(
          //       hintText: 'Search accounts...',
          //       hintStyle: TextStyle(color: TColor.placeholder),
          //       prefixIcon: Icon(Icons.search, color: TColor.secondary),
          //       filled: true,
          //       fillColor: TColor.textfield,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide.none,
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide.none,
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //         borderSide: BorderSide(color: TColor.secondary),
          //       ),
          //     ),
          //   ),
          // ),
          SearchTextField(
            hintText: 'Search Accounts...',
            controller: _searchController,
            onChange: _searchAccounts,
          ),
          Expanded(
            child: ListView.builder(
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
                                Get.to(()=> const LedgerScreen());
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
