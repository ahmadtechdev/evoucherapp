
  import 'package:evoucher/common_widget/round_textfield.dart';
  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';

  import '../../common/color_extension.dart';
  import '../../common/drawer.dart';

  class CustomerReportScreen extends StatefulWidget {
    const CustomerReportScreen({super.key});

    @override
    State<CustomerReportScreen> createState() => _CustomerReportScreenState();
  }

  class _CustomerReportScreenState extends State<CustomerReportScreen> {
    int selectedYear = 2024;
    final searchController = TextEditingController();

    final List<Map<String, dynamic>> activeCustomers = [
      {
        'rank': 1,
        'name': 'MOHSIN ALI',
        'ticket': 0.00,
        'hotel': 385000.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 385000.00,
        'percentage': 42.2524
      },
      {
        'rank': 2,
        'name': 'AHMED C/O MUNIR',
        'ticket': 60000.00,
        'hotel': 100000.00,
        'visa': 50480.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 210480.00,
        'percentage': 23.0995
      },
      {
        'rank': 3,
        'name': 'HUSSNAIN ALI',
        'ticket': 23860.00,
        'hotel': 124000.00,
        'visa': 32850.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 180710.00,
        'percentage': 19.8323
      },
      {
        'rank': 4,
        'name': 'ALI AMEEN',
        'ticket': 80000.00,
        'hotel': 25000.00,
        'visa': 30000.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 135000.00,
        'percentage': 14.8158
      },
    ];
    final List<Map<String, dynamic>> zeroSaleCustomers = [
      {
        'rank': 5,
        'name': 'MR Afaq',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 6,
        'name': 'Mr. Adnan',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 7,
        'name': 'Mr. Adnan Kashif',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
      {
        'rank': 8,
        'name': 'MEHRAN WALKING CUSTOMER',
        'ticket': 0.00,
        'hotel': 0.00,
        'visa': 0.00,
        'transport': 0.00,
        'other': 0.00,
        'total': 0.00,
        'percentage': 0.0000
      },
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: TColor.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
          title: const Text('Top Customer Sale Report'),
        ),
        drawer: const CustomDrawer(currentIndex: 15),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: TColor.secondaryText.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int>(
                        value: selectedYear,
                        underline: const SizedBox(),
                        items: List.generate(5, (index) => 2024 - index).map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text('YEAR - $year'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedYear = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Print Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: TColor.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                SearchTextField(hintText: "Search...", onChange: (date) {}),

                Expanded(
                  child: ListView(
                    children: [
                      // Active Customers Section
                      ...activeCustomers.map((customer) => _buildCustomerCard(customer)),

                      // Zero Sales Section Header
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Accounts with Zero Sales',
                          style: TextStyle(
                            color: TColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Zero Sales Customers
                      ...zeroSaleCustomers.map((customer) => _buildCustomerCard(customer)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildCustomerCard(Map<String, dynamic> customer) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: TColor.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rank ${customer['rank']}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      customer['name'],
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${customer['percentage'].toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: TColor.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildSaleItem('Ticket Sale', customer['ticket'], TColor.primary),
                  _buildSaleItem('Hotel Sale', customer['hotel'], TColor.secondary),
                  _buildSaleItem('Visa Sale', customer['visa'], TColor.third),
                  _buildSaleItem('Transport Sale', customer['transport'], TColor.fourth),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColor.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Sale',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs. ${NumberFormat('#,##0.00').format(customer['total'])}',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSaleItem(String title, double amount, Color color) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rs. ${NumberFormat('#,##0.00').format(amount)}',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }