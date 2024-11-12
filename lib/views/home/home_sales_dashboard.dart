import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';

class SalesDashboardWidget extends StatefulWidget {
  const SalesDashboardWidget({super.key});

  @override
  State<SalesDashboardWidget> createState() => _SalesDashboardWidgetState();
}

class _SalesDashboardWidgetState extends State<SalesDashboardWidget> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: TColor.white,
              surface: TColor.white,
              onSurface: TColor.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        final isTablet = constraints.maxWidth > 600;
        final cardPadding = isTablet ? 16.0 : 12.0;
        final fontSize = isTablet ? 16.0 : 14.0;
        final iconSize = isTablet ? 34.0 : 30.0;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(fontSize),
                const SizedBox(height: 20),
                _buildSalesGrid(constraints, cardPadding, fontSize, iconSize),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector(double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TColor.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'SALES ON:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: TColor.primaryText,
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TColor.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: TColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_today,
                    size: fontSize,
                    color: TColor.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesGrid(BoxConstraints constraints, double padding, double fontSize, double iconSize) {
    final crossAxisCount = constraints.maxWidth > 600 ? 2 : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: padding,
      crossAxisSpacing: padding,
      childAspectRatio:  0.9,
      children: [
        _buildSalesCard(
          'Ticket Sales',
          'PKR 0',
          Icons.flight,
          TColor.primary,
          padding,
          fontSize,
          iconSize,
        ),
        _buildSalesCard(
          'Hotel Sales',
          'PKR 0',
          Icons.business,
          TColor.secondary,
          padding,
          fontSize,
          iconSize,
        ),
        _buildSalesCard(
          'Visa Sales',
          'PKR 0',
          Icons.credit_card,
          TColor.third,
          padding,
          fontSize,
          iconSize,
        ),
        _buildSalesCard(
          'Grand Total',
          'PKR 0',
          Icons.folder,
          Color.lerp(TColor.primary, TColor.secondary, 0.5)!,
          padding,
          fontSize,
          iconSize,
        ),

      ],
    );
  }

  Widget _buildSalesCard(
      String title,
      String amount,
      IconData iconData,
      Color color,
      double padding,
      double fontSize,
      double iconSize,
      ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Handle card tap
                },
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Add this
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12), // Reduced padding
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          iconData,
                          color: color,
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: TColor.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: fontSize * 1.2,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      TextButton(
                        onPressed: () {
                          // Handle view more action
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: color,
                          padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced padding
                          minimumSize: Size.zero, // Allow button to be smaller
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View More',
                              style: TextStyle(fontSize: fontSize * 0.85), // Slightly smaller font
                            ),
                            SizedBox(width: 4), // Add small spacing
                            Icon(Icons.arrow_forward, size: fontSize * 0.85), // Match text size
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}