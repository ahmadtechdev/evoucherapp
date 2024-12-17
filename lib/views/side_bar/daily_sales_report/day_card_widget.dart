import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/color_extension.dart';

class DayCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> dayData;

  const DayCard({
    super.key,
    required this.index,
    required this.dayData,
  });

  @override
  DayCardState createState() => DayCardState();
}

class DayCardState extends State<DayCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.dayData['summary'];
    final details = widget.dayData['details'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entry #${widget.index + 1}',
                      style: TextStyle(
                        color: TColor.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, dd MMM yyyy')
                          .format(DateTime.parse(widget.dayData['date'])),
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isExpanded ? 'Hide' : 'Detail',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'V#: ${summary['vNo']}',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'V.Date: ${details['vDate']}',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customer Account: ${details['cAccount']}',
                    style: TextStyle(
                      color: TColor.secondary,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Supplier Account: ${details['sAccount']}',
                    style: TextStyle(
                      color: TColor.third,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pax Name: ${details['paxName']}',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.visibility,
                          color: TColor.primary,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          _buildSummaryRow('Total Purchases:',
              'Rs.${NumberFormat('#,###').format(summary['totalP'])}', TColor.secondaryText),
          _buildSummaryRow('Total Sales:',
              'Rs.${NumberFormat('#,###').format(summary['totalS'])}', TColor.secondaryText),
          _buildSummaryRow(
            'Profit/Loss',
            'Rs.${NumberFormat('#,###').format(summary['pL'])}',
            summary['pL'] >= 0 ? TColor.secondary : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
