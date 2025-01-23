import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/color_extension.dart';
import '../models/top_supplier_sale_model.dart';
import 'sale_item.dart';


class SupplierCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
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
                    'Rank ${supplier.rank}',
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    supplier.name,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${supplier.percentage.toStringAsFixed(2)}%',
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
                SaleItem(title: 'Ticket Sale', amount: supplier.ticket, color: TColor.primary),
                SaleItem(title: 'Hotel Sale', amount: supplier.hotel, color: TColor.secondary),
                SaleItem(title: 'Visa Sale', amount: supplier.visa, color: TColor.third),
                SaleItem(title: 'Transport Sale', amount: supplier.transport, color: TColor.fourth),
              ],
            ),
            const SizedBox(height: 8),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
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
            'Rs. ${NumberFormat('#,##0.00').format(supplier.total)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}