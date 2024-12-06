import 'package:evoucher/views/accounts/accounts_ledger/view_accounts_ledger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';

class FiveYearsCustomerSale extends StatefulWidget {
  const FiveYearsCustomerSale({Key? key}) : super(key: key);

  @override
  State<FiveYearsCustomerSale> createState() => _FiveYearsCustomerSaleState();
}

class _FiveYearsCustomerSaleState extends State<FiveYearsCustomerSale> {
  String? selectedYear; // Changed to nullable String
  String searchQuery = "";

  final List<String> years = ["2020", "2021", "2022", "2023", "2024"];
  final List<Map<String, dynamic>> salesData = [
    {"name": "ALI AMEEN", "2020": 0.0, "2021": 0.0, "2022": 0.0, "2023": 775000.00, "2024": 135000.00, "total": 910000.00},
    {"name": "MOHSIN ALI", "2020": 0.0, "2021": 0.0, "2022": 301766.00, "2023": 0.0, "2024": 385000.00, "total": 686766.00},
    {"name": "AHMED KHAN", "2020": 100000.00, "2021": 200000.00, "2022": 150000.00, "2023": 300000.00, "2024": 400000.00, "total": 1150000.00},
    {"name": "USMAN SAEED", "2020": 50000.00, "2021": 0.0, "2022": 100000.00, "2023": 200000.00, "2024": 250000.00, "total": 600000.00},
    {"name": "KASHIF ALI", "2020": 0.0, "2021": 75000.00, "2022": 125000.00, "2023": 175000.00, "2024": 250000.00, "total": 625000.00},
    {"name": "FAHAD RAZA", "2020": 25000.00, "2021": 50000.00, "2022": 75000.00, "2023": 100000.00, "2024": 150000.00, "total": 400000.00},
    {"name": "ASIF IQBAL", "2020": 0.0, "2021": 0.0, "2022": 200000.00, "2023": 300000.00, "2024": 350000.00, "total": 850000.00},
    {"name": "SAQIB JAVED", "2020": 100000.00, "2021": 150000.00, "2022": 0.0, "2023": 200000.00, "2024": 300000.00, "total": 750000.00},
    {"name": "TANVIR HUSSAIN", "2020": 0.0, "2021": 50000.00, "2022": 100000.00, "2023": 150000.00, "2024": 250000.00, "total": 550000.00},
    {"name": "HASSAN SHAH", "2020": 75000.00, "2021": 100000.00, "2022": 125000.00, "2023": 150000.00, "2024": 175000.00, "total": 625000.00},
  ];

  List<Map<String, dynamic>> get filteredData {
    var filtered = salesData
        .where((sale) =>
        sale["name"].toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Only sort if a year is selected
    if(selectedYear != null) {
      filtered.sort((a, b) {
        double valueA = a[selectedYear] as double;
        double valueB = b[selectedYear] as double;

        if ((valueA == 0 && valueB == 0) || (valueA != 0 && valueB != 0)) {
          return 0;
        }
        if (valueA == 0) {
          return -1;
        }
        return 1;
      });
    }

    return filtered;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('5 Year Customer Sale Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 16),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                boxShadow: [
                  BoxShadow(
                    color: TColor.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: TColor.textfield,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search accounts...",
                          hintStyle: TextStyle(color: TColor.placeholder),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: TColor.secondary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: TColor.textfield,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedYear, // Now can be null
                        hint: const Text("Select Year"), // Shows when no year is selected
                        items: years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final sale = filteredData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.primary.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                        // onTap: () => Get.to(() => const LedgerScreen(accountId: '',))
                        //
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    sale["name"],
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TColor.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${sale["total"].toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: years.map((year) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      year,
                                      style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat('#,##0.00').format(sale[year]),
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}