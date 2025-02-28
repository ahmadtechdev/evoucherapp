
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/color_extension.dart';
import '../../../common/drawer.dart';
import '../../../common_widget/round_text_field.dart';
import 'controller/recovery_list_controller.dart';
import 'models/recovery_list_modal_class.dart';
import 'widgets/recovery_list_card.dart';

class RecoveryListsScreen extends StatelessWidget {
  final RecoveryListController controller = Get.put(RecoveryListController());

  RecoveryListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        title: const Text('Recovery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchRecoveryLists(),
          ),
        ],
      ),
      drawer: const CustomDrawer(currentIndex: 10),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchTextField(
              hintText: 'Search...',
              onChange: (value) {
                controller.searchQuery.value = value;
              },
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: TColor.primary,
                    ),
                  );
                }

                final items = controller.filteredList;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No recovery lists found',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchRecoveryLists,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return RecoveryListCard(
                        rlName: item.rlName,
                        dateCreated: item.dateCreated,
                        totalAmount: item.totalAmount,
                        received: item.received,
                        remaining: item.remaining,
                        onGetPdfPressed: () => controller.exportToPDF(context),
                        onDetailsPressed: () =>
                            _showDetailsDialog(context, item),
                        onUpdatePressed: () => _showAddEditDialog(
                          context,
                          existingItem: item,
                          index: index,
                        ),
                        onDeletePressed: () =>
                            controller.deleteRecoveryItem(index),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, RecoveryListModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          title: Text(
            'Recovery List Details',
            style: TextStyle(
              color: TColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', item.rlName),
              _buildDetailRow('Date Created', item.dateCreated),
              _buildDetailRow(
                  'Total Amount', '\$${item.totalAmount.toStringAsFixed(2)}'),
              _buildDetailRow(
                  'Received', '\$${item.received.toStringAsFixed(2)}'),
              _buildDetailRow(
                  'Remaining', '\$${item.remaining.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: TColor.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context,
      {RecoveryListModel? existingItem, int? index}) {
    final nameController =
        TextEditingController(text: existingItem?.rlName ?? '');
    final dateController =
        TextEditingController(text: existingItem?.dateCreated ?? '');
    final totalAmountController = TextEditingController(
        text: existingItem?.totalAmount.toStringAsFixed(2) ?? '');
    final receivedController = TextEditingController(
        text: existingItem?.received.toStringAsFixed(2) ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 10,
          backgroundColor: TColor.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      existingItem == null
                          ? 'Add Recovery List'
                          : 'Edit Recovery List',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  RoundTextField(
                      hintText: "Account Name", controller: nameController),
                  const SizedBox(height: 12),
                  RoundTextField(
                      hintText: "Date Created",
                      controller: dateController), // Use DateSelector as needed
                  const SizedBox(height: 12),
                  RoundTextField(
                      hintText: "Total Amount",
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: totalAmountController),
                  const SizedBox(height: 12),
                  RoundTextField(
                      hintText: "Received Amount",
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: receivedController),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                            foregroundColor: TColor.third,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final newItem = RecoveryListModel(
                            rlName: nameController.text,
                            dateCreated: dateController.text,
                            totalAmount:
                                double.parse(totalAmountController.text),
                            received: double.parse(receivedController.text),
                            remaining:
                                double.parse(totalAmountController.text) -
                                    double.parse(receivedController.text),
                            id: '',
                            formatted: {},
                          );

                          if (existingItem == null) {
                            controller.addRecoveryItem(newItem);
                          } else {
                            controller.updateRecoveryItem(index!, newItem);
                          }

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.secondary,
                            foregroundColor: TColor.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
