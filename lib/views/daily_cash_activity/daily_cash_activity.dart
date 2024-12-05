import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/dart_selector2.dart';

class DailyCashActivity extends StatefulWidget {
  const DailyCashActivity({super.key});

  @override
  State<DailyCashActivity> createState() => _DailyCashActivityState();
}

class _DailyCashActivityState extends State<DailyCashActivity> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Daily Cash Report'),
      ),
      drawer: const CustomDrawer(currentIndex: 5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2.5,
                    child: DateSelector2(
                      label: "Select Date:",
                        fontSize: 12,
                        initialDate: selectedDate,
                        onDateChanged: (date) {}),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text('Print Report',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                'Date: ${DateFormat('E, dd MMM yyyy').format(selectedDate)}',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildSummaryCard(
                    'Opening Balance',
                    'PKR 39,901 Cr',
                    TColor.primary,
                    Icons.account_balance,
                  ),
                  _buildSummaryCard(
                    'Total Cash Received',
                    'Rs. 25.00',
                    TColor.secondary,
                    Icons.arrow_downward,
                  ),
                  _buildSummaryCard(
                    'Total Cash Paid',
                    'Rs. 25.00',
                    TColor.third,
                    Icons.arrow_upward,
                  ),
                  _buildSummaryCard(
                    'Closing Balance',
                    'Rs. -39,901',
                    TColor.fourth,
                    Icons.account_balance_wallet,
                  ),
                ],
              ),
            ),
            _buildSection(
              'Cash Received',
              TColor.secondary,
              [
                _Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),_Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),_Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),
              ],
            ),
            _buildSection(
              'Cash Paid',
              TColor.third,
              [
                _Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),_Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),_Transaction(
                  voucherNo: 'CV 877',
                  account: 'Afaq Travels',
                  description: 'TEST',
                  status: 'Posted',
                  amount: '25.00',
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalItem('Total Received', '25', TColor.secondary),
                  _buildTotalItem('Total Paid', '25', TColor.third),
                  _buildTotalItem('Closing Balance', '-39901', TColor.fourth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12,),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, Color color, List<_Transaction> transactions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...transactions.map((transaction) => _buildTransactionCard(
                transaction,
                color,
              )),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(_Transaction transaction, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      color: TColor.white,
      shadowColor:TColor.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.voucherNo,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.account,
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.description,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Rs. ${transaction.amount}',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Transaction {
  final String voucherNo;
  final String account;
  final String description;
  final String status;
  final String amount;

  _Transaction({
    required this.voucherNo,
    required this.account,
    required this.description,
    required this.status,
    required this.amount,
  });
}
