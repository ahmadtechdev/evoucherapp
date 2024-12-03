import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class InvoiceSettlementPage extends StatefulWidget {
  @override
  _InvoiceSettlementPageState createState() => _InvoiceSettlementPageState();
}

class _InvoiceSettlementPageState extends State<InvoiceSettlementPage> {
  // Keep your existing dummy data
  final List<Map<String, dynamic>> invoices = [
    {
      "id": "TV-113",
      "date": "Fri, 27 Jan 2023",
      "description": "ABC-1234y34567887-HJH-BVJ-ST",
      "totalAmount": 536.00,
      "settledAmount": 0.00,
      "remainingAmount": 536.00,
    },
    {
      "id": "HV-320",
      "date": "Wed, 19 Jul 2023",
      "description": "UpdTEST-TESTHOTELNAME-FAISALABAD-AFGHANISTAN",
      "totalAmount": 60.00,
      "settledAmount": 0.00,
      "remainingAmount": 60.00,
    },
    {
      "id": "HV-321",
      "date": "Wed, 19 Jul 2023",
      "description": "UpdTEST-TESTHOTELNAME-FAISALABAD-AFGHANISTAN",
      "totalAmount": 1.00,
      "settledAmount": 0.00,
      "remainingAmount": 1.00,
    },
    {
      "id": "TV-327",
      "date": "Fri, 04 Aug 2023",
      "description": "AFAQALI-21445464541655-LHE-KHI-PK",
      "totalAmount": 16500.00,
      "settledAmount": 3000.00,
      "remainingAmount": 13500.00,
    },
    {
      "id": "VV-328",
      "date": "Fri, 04 Aug 2023",
      "description": "AFAQ-EK12151-UMMRAH--KSA(P)",
      "totalAmount": 8000.00,
      "settledAmount": 0.00,
      "remainingAmount": 8000.00,
    },
  ];

  List<Map<String, dynamic>> selectedInvoices = [];
  double totalPayment = 50000.00;

  double get totalSettled =>
      selectedInvoices.fold(0.0, (sum, invoice) => sum + (invoice['settled'] ?? 0.0));
  double get difference => totalPayment - totalSettled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: TColor.primary,
          foregroundColor: TColor.white,
          title: const Text('Invoice Settlement'),
        ),
        body: Stack(
          children: [
            // Main content (Unsettled Invoices)
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Payment Details Card
                      Card(
                        margin: const EdgeInsets.all(16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.green.shade50,
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Center(
                                child: Text(
                                  "Selected Payment Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // ID and Date Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CV-329",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  Text(
                                    "04 Aug 2023",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Description
                              Text(
                                "Cash received from AFAQ Travel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Total Amount
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "50,000.00 PKR",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "All Un-Settled Invoices",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: TColor.primary,
                            ),
                          ),
                        ),
                      ),

                      // Unsettled Invoices List
                      ...invoices.map((invoice) {
                        bool isSelected = selectedInvoices.contains(invoice);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedInvoices.remove(invoice);
                              } else {
                                selectedInvoices.add(invoice);
                              }
                            });
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            elevation: isSelected ? 6 : 4, // Higher elevation for selected state
                            shadowColor: isSelected ? TColor.secondary : TColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? TColor.secondary : TColor.primary,
                                width: isSelected ? 2 : 1, // Border width increases for selected
                              ),
                            ),
                            color: isSelected
                                ? TColor.secondary.withOpacity(0.9)
                                : TColor.white, // Background changes for selected
                            child: Padding(
                              padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        invoice['id'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? TColor.white // White text for better contrast in selected
                                              : TColor.primaryText,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? TColor.white.withOpacity(0.8) // Highlighted background
                                              : TColor.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "${invoice['remainingAmount']} PKR",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? TColor.secondary // Highlighted text color
                                                : TColor.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Date: ${invoice['date']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? TColor.white.withOpacity(0.8) // Subtle text for selected
                                          : TColor.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    invoice['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? TColor.white // White for better contrast
                                          : TColor.primaryText.withOpacity(0.8),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Add extra padding at bottom for DraggableScrollableSheet
                      SizedBox(height: selectedInvoices.isEmpty ? 0 : 300),
                    ],
                  ),
                ),
              ],
            ),

            // Selected Invoices Sheet
            if (selectedInvoices.isNotEmpty)
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: TColor.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Selected Invoices to be Settled",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: TColor.secondary,
                                    ),
                                  ),
                                ),
                              ),
                              ...selectedInvoices.map((invoice) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  elevation: 4,
                                  shadowColor: TColor.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color:  TColor.secondary ,
                                      width:  1, // Border width increases for selected
                                    ),
                                  ),
                                  color: TColor.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              invoice['id'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: TColor.primaryText,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: TColor.third.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "${invoice['remainingAmount']} PKR",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: TColor.third,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          invoice['description'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                            TColor.primaryText.withOpacity(0.8),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text("Settle Amount: "),
                                            Expanded(
                                              child: RoundTextfield(
                                                hintText: "Enter amount",
                                                keyboardType: TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    invoice['settled'] =
                                                        double.tryParse(value) ?? 0.0;
                                                  });
                                                },
                                              ),
                                              // child: TextField(
                                              //   keyboardType: TextInputType.number,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       invoice['settled'] =
                                              //           double.tryParse(value) ?? 0.0;
                                              //     });
                                              //   },
                                              //   decoration: InputDecoration(
                                              //     hintText: "Enter amount",
                                              //     filled: true,
                                              //     fillColor: TColor.textfield,
                                              //     border: OutlineInputBorder(
                                              //       borderSide: BorderSide.none,
                                              //       borderRadius:
                                              //       BorderRadius.circular(5),
                                              //     ),
                                              //   ),
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),

                        // Total Payment Section
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: TColor.white,
                            boxShadow: [
                              BoxShadow(
                                color: TColor.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Payment: $totalPayment",
                                        style: TextStyle(fontSize: 16, color: TColor.third),
                                      ),
                                      Text(
                                        "Difference: $difference",
                                        style: TextStyle(fontSize: 16, color: TColor.primary),
                                      ),
                                      Text(
                                        "Payment to Settle: $totalSettled",
                                        style: TextStyle(fontSize: 16, color: TColor.secondary),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle settlement logic
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TColor.secondary,
                                      foregroundColor: TColor.white,
                                    ),
                                    child: const Text("Settle Now"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}