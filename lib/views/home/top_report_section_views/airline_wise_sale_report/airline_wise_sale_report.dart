import 'package:evoucher_new/common/color_extension.dart';
import 'package:flutter/material.dart';

class AirlineWiseSaleReport extends StatefulWidget {
  const AirlineWiseSaleReport({super.key});

  @override
  AirlineWiseSaleReportState createState() => AirlineWiseSaleReportState();
}

class AirlineWiseSaleReportState extends State<AirlineWiseSaleReport> {
  final List<Map<String, dynamic>> data = [
    {
      'Date': 'Wed, 13 Nov 2024',
      'Pax': 'SHARIQ JAMAD MR',
      'Ticket': '2172006322022',
      'Sector': 'LHE-BKK/KUL-SIN-BKK-BKK-HE',
      'Base Fare': 118550,
      'Taxes': 97231,
      'EMD': 0,
      'CC': 0,
      'Air Comm': 0.0,
      'Air WHT': 0,
      'Buying': 215781.0
    },
    {
      'Date': 'Wed, 13 Nov 2024',
      'Pax': 'JAWED ASEEM MS',
      'Ticket': '2172006322024',
      'Sector': 'LHE-BKK/KUL-SIN-BKK-HE',
      'Base Fare': 118550,
      'Taxes': 97231,
      'EMD': 0,
      'CC': 0,
      'Air Comm': 0.0,
      'Air WHT': 0,
      'Buying': 215781.0
    },
  ];

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  String? _selectedFrom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title: const Text('Thai Airways - TG Sales Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: TColor.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterRow(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return _buildTransactionCard(item);
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildTotalSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Expanded(child: _buildDateField(_fromDateController, 'From Date')),
        const SizedBox(width: 8),
        Expanded(child: _buildDateField(_toDateController, 'To Date')),
        const SizedBox(width: 8),
        Expanded(child: _buildAirlineField()),
        const SizedBox(width: 8),
        Expanded(child: _buildFromDropdown()),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: TColor.secondary),
          child: Text('Submit', style: TextStyle(color: TColor.white)),
        ),
      ],
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: TColor.textField,
        border: _getInputBorder(),
      ),
    );
  }

  Widget _buildAirlineField() {
    return TextField(
      controller: _airlineController,
      decoration: InputDecoration(
        hintText: 'Airline',
        filled: true,
        fillColor: TColor.textField,
        border: _getInputBorder(),
      ),
    );
  }

  Widget _buildFromDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFrom,
      decoration: InputDecoration(
        hintText: 'From',
        filled: true,
        fillColor: TColor.textField,
        border: _getInputBorder(),
      ),
      items: ['ESP', 'INTERNATIONAL'].map(_buildDropdownItem).toList(),
      onChanged: (value) => setState(() => _selectedFrom = value),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value) {
    return DropdownMenuItem(value: value, child: Text(value));
  }

  Widget _buildTransactionCard(Map<String, dynamic> item) {
    return _getCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(item),
          const SizedBox(height: 10),
          Text('Passenger: ${item['Pax']}', style: _getNameStyle()),
          const SizedBox(height: 10),
          Text('Sector: ${item['Sector']}', style: _getSecondaryStyle()),
          const SizedBox(height: 10),
          _buildFinancialRow(item),
        ],
      ),
    );
  }

  Widget _buildTopRow(Map<String, dynamic> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item['Date'], style: _getPrimaryStyle()),
        Text('Ticket: ${item['Ticket']}', style: _getSecondaryStyle()),
      ],
    );
  }

  Widget _buildFinancialRow(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: TColor.textField,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildFinancialItem(
              'Base Fare', '₹${item['Base Fare']}', TColor.primary),
          const SizedBox(height: 8),
          _buildFinancialItem('Taxes', '₹${item['Taxes']}', TColor.third),
          const SizedBox(height: 8),
          _buildFinancialItem('EMD', '₹${item['EMD']}', TColor.secondary),
          const SizedBox(height: 8),
          _buildFinancialItem('CC', '₹${item['CC']}', TColor.fourth),
          const SizedBox(height: 8),
          _buildFinancialItem(
              'Air Comm', '₹${item['Air Comm']}', TColor.secondaryText),
          const SizedBox(height: 8),
          _buildFinancialItem(
              'Air WHT', '₹${item['Air WHT']}', TColor.secondaryText),
          const SizedBox(height: 8),
          _buildFinancialItem('Total', '₹${item['Buying']}', TColor.primary),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _getSecondaryStyle()),
        Text(value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTotalSummary() {
    return _getCard(
      child: Column(
        children: [
          _buildTotalItem('Total Base Fare', '₹722,070.00', TColor.primary),
          const SizedBox(height: 10),
          _buildTotalItem('Total Taxes', '₹813,240.00', TColor.third),
          const SizedBox(height: 10),
          _buildTotalItem('Total EMD', '₹0.00', TColor.secondary),
          const SizedBox(height: 10),
          _buildTotalItem('Total CC', '₹0.00', TColor.fourth),
          const SizedBox(height: 10),
          _buildTotalItem('Total Air Comm', '₹0.00', TColor.secondary),
          const SizedBox(height: 10),
          _buildTotalItem('Total Air WHT', '₹0.00', TColor.fourth),
          const SizedBox(height: 10),
          _buildTotalItem('Total', '₹1,339,218.00', TColor.primary),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _getSecondaryStyle()),
        Text(value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _getCard({required Widget child}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [TColor.white, TColor.textField.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  InputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: TColor.placeholder),
    );
  }

  TextStyle _getPrimaryStyle() {
    return TextStyle(
      color: TColor.primary,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _getNameStyle() {
    return TextStyle(
      color: TColor.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _getSecondaryStyle() {
    return TextStyle(
      color: TColor.secondaryText,
    );
  }
}
