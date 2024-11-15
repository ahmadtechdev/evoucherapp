import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/date_selecter.dart';

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
                DateSelector(
                  fontSize: fontSize,
                  initialDate: selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
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
                            const SizedBox(width: 4), // Add small spacing
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