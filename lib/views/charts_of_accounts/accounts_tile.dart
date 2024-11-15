import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import 'modal.dart';

class AccountCard extends StatelessWidget {
  final AccountItem account;

  const AccountCard({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: TColor.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: TColor.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: TColor.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: TColor.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            account.phoneNumber,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.visibility,
                    color: TColor.primary,
                  ),
                  onPressed: () {
                    // Handle view action
                    showAccountDetails(context, account);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Opening Debit',
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Dr: ${account.openingDebit.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: TColor.third,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Opening Credit',
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Cr: ${account.openingCredit.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: TColor.fourth,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAccountDetails(BuildContext context, AccountItem account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Account Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${account.id}'),
            const SizedBox(height: 8),
            Text('Name: ${account.name}'),
            const SizedBox(height: 8),
            Text('Phone: ${account.phoneNumber}'),
            const SizedBox(height: 16),
            Text('Opening Debit: ${account.openingDebit.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Opening Credit: ${account.openingCredit.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}