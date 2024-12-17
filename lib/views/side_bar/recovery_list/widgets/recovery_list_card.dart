
import 'package:flutter/material.dart';

import '../../../../common/color_extension.dart';

class RecoveryListCard extends StatelessWidget {
  final String rlName;
  final String dateCreated;
  final double totalAmount;
  final double received;
  final double remaining;
  final VoidCallback onDetailsPressed;
  final VoidCallback onUpdatePressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onGetPdfPressed;

  const RecoveryListCard({super.key,
    required this.rlName,
    required this.dateCreated,
    required this.totalAmount,
    required this.received,
    required this.remaining,
    required this.onDetailsPressed,
    required this.onUpdatePressed,
    required this.onDeletePressed,
    required this.onGetPdfPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: TColor.white,
      shadowColor: TColor.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rlName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date Created: $dateCreated',
              style: TextStyle(
                fontSize: 14.0,
                color: TColor.secondaryText,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardItem('Total Amount', totalAmount.toStringAsFixed(2)),
                _buildCardItem('Received', received.toStringAsFixed(2)),
                _buildCardItem('Remaining', remaining.toStringAsFixed(2)),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Details', onDetailsPressed, TColor.primary),
                _buildActionButton('Update', onUpdatePressed, TColor.secondary),
                _buildActionButton('Delete', onDeletePressed, TColor.third),
                _buildActionButton('Get PDF', onGetPdfPressed, TColor.fourth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            color: TColor.secondaryText,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: TColor.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: TColor.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(label),
    );
  }
}