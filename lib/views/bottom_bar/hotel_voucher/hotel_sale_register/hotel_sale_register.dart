import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/color_extension.dart';
import '../../../../common_widget/dart_selector2.dart';
import 'hotel_sale_register_controller.dart';

class HotelSaleRegisterScreen extends StatelessWidget {
  HotelSaleRegisterScreen({super.key}) {
    Get.put(HotelSaleRegisterController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HotelSaleRegisterController());

    return Scaffold(
      backgroundColor: TColor.textField,
      appBar: AppBar(
        title: Text(
          'Hotel Sale Register',
          style: TextStyle(color: TColor.white),
        ),
        backgroundColor: TColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Date Range Selector with enhanced shadow
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              boxShadow: [
                BoxShadow(
                  color: TColor.primaryText.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => DateSelector2(
                        fontSize: 14,
                        initialDate: controller.fromDate.value,
                        onDateChanged: (DateTime date) {
                          controller.fromDate.value = date;
                          controller.fetchHotelSaleRegisterData();
                        },
                        label: 'From Date',
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => DateSelector2(
                        fontSize: 14,
                        initialDate: controller.toDate.value,
                        onDateChanged: (DateTime date) {
                          controller.toDate.value = date;
                          controller.fetchHotelSaleRegisterData();
                        },
                        label: 'To Date',
                      )),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              boxShadow: [
                BoxShadow(
                  color: TColor.primaryText.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => controller.updateSearchQuery(value),
              decoration: InputDecoration(
                hintText:
                    'Search by voucher name, ID, customer account, or sector...',
                hintStyle: TextStyle(color: TColor.secondaryText),
                prefixIcon: Icon(Icons.search, color: TColor.primary),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: TColor.secondaryText),
                        onPressed: () => controller.clearSearch(),
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: TColor.textField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: TColor.primary, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Loading or Error State
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.errorMessage.value != null) {
              return Expanded(
                child: Center(
                  child: Text(
                    controller.errorMessage.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            // Booking List with enhanced scrolling
            return Expanded(
              child: Obx(() => controller.filteredDailyRecords.isEmpty
                  ? Center(
                      child: Text(
                      controller.searchQuery.value.isNotEmpty
                          ? 'No records found matching "${controller.searchQuery.value}"'
                          : 'No records found',
                      style: TextStyle(color: TColor.secondaryText),
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.filteredDailyRecords.length,
                      itemBuilder: (context, index) {
                        return _buildDailyBookingSection(
                            controller.filteredDailyRecords[index]);
                      },
                    )),
            );
          }),
        ],
      ),
      floatingActionButton: _buildTotalSummaryFAB(),
    );
  }

  Widget _buildDailyBookingSection(dynamic dailyData) {
    if (dailyData == null || dailyData['tickets'] == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Date Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: TColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dailyData['date'] ?? 'Unknown Date',
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Enhanced Daily Summary Card
        _buildDailySummaryCard(dailyData['totals'] ?? {}),

        // Booking Cards
        ...?dailyData['tickets']
            ?.map<Widget>((booking) => _buildBookingCard(booking)),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryText.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${booking['voucher_number'] ?? 'N/A'}',
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  booking['conf_number'] ?? 'N/A',
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Booking Details with improved layout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResponsiveDetailRow(
                    'Voucher ID', booking['voucher_id'] ?? 'N/A'),
                _buildResponsiveDetailRow(
                    'Pax Name', booking['pax_name'] ?? 'N/A'),
                _buildResponsiveDetailRow(
                    'Customer Account', booking['customer_account'] ?? 'N/A',
                    isWrappable: true),
                _buildResponsiveDetailRow(
                    'Check In', booking['check_in'] ?? 'N/A'),
                _buildResponsiveDetailRow(
                    'Check Out', booking['check_out'] ?? 'N/A'),
                _buildResponsiveDetailRow('Sector', booking['sector'] ?? 'N/A'),
                _buildResponsiveDetailRow(
                    'Supplier Account', booking['supplier_account'] ?? 'N/A',
                    isWrappable: true),

                const Divider(height: 24),

                // Enhanced Financial Details
                _buildFinancialRow(
                    'Buying',
                    'Rs. ${NumberFormat('#,##0.00').format(double.tryParse(booking['buying_amount']?.toString() ?? '0') ?? 0)}',
                    TColor.third),
                _buildFinancialRow(
                    'Selling',
                    'Rs. ${NumberFormat('#,##0.00').format(double.tryParse(booking['selling_amount']?.toString() ?? '0') ?? 0)}',
                    TColor.secondary),

                if (booking['profit_loss'] != null)
                  _buildFinancialRow(
                      '${booking['profit_loss']['type']?.toUpperCase() ?? 'Profit'}',
                      'Rs. ${NumberFormat('#,##0.00').format(double.tryParse(booking['profit_loss']['amount']?.toString() ?? '0') ?? 0)}',
                      TColor.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveDetailRow(String label, String value,
      {bool isWrappable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: isWrappable
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
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

  Widget _buildDailySummaryCard(dynamic totals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryText.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSummaryItem(
                'Rows', totals['total_rows'].toString(), TColor.primary),
            const SizedBox(width: 16),
            _buildSummaryItem(
                'Buying', totals['total_buying'], TColor.secondary),
            const SizedBox(width: 16),
            _buildSummaryItem('Selling', totals['total_selling'], TColor.third),
            const SizedBox(width: 16),
            _buildSummaryItem(
                'Profit', totals['total_profit_loss'], TColor.fourth),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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

  Widget _buildTotalSummaryFAB() {
    return FloatingActionButton.extended(
      onPressed: _showTotalSummaryBottomSheet,
      backgroundColor: TColor.primary,
      icon: Icon(Icons.summarize, color: TColor.white),
      label: Text(
        '',
        style: TextStyle(color: TColor.white),
      ),
    );
  }

  void _showTotalSummaryBottomSheet() {
    final controller = Get.find<HotelSaleRegisterController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: TColor.primaryText.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: TColor.secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Total Summary',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final totals = controller.filteredTotalSummary.value;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryStatItem('Total Rows',
                        totals['total_rows'].toString(), TColor.primary),
                    const SizedBox(width: 16),
                    _buildSummaryStatItem('Total Buying',
                        totals['total_buying'], TColor.secondary),
                    const SizedBox(width: 16),
                    _buildSummaryStatItem(
                        'Total Selling', totals['total_selling'], TColor.third),
                    const SizedBox(width: 16),
                    _buildSummaryStatItem('Total Profit',
                        totals['total_profit_loss'], TColor.fourth),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
    );
  }

  Widget _buildSummaryStatItem(String label, String value, Color color) {
    // Format the value if it's a number
    String displayValue = value;
    if (value != "0") {
      try {
        final numValue = double.tryParse(value.replaceAll(',', ''));
        if (numValue != null) {
          displayValue = NumberFormat('#,##0.00').format(numValue);
        }
      } catch (_) {
        // Keep original value if parsing fails
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayValue,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
