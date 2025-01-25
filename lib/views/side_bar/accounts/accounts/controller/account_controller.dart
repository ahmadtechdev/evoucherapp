import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_service.dart';
import '../models/accounts_modal_class.dart';

class AccountsRepository {
  final ApiService api;

  AccountsRepository({required this.api});

  Future<List<AccountModel>> getAccounts({String? subheadName}) async {
    final response = await api.postRequest(
      endpoint: 'fetchAccounts',
      body: subheadName != null ? {"subhead_name": subheadName} : {},
    );

    if (response['status'] == 'success' && response['data'] != null) {
      return (response['data'] as List)
          .map((json) => AccountModel.fromJson(json))
          .toList();
    }

    throw Exception('Failed to fetch accounts');
  }
}

class AccountsController extends GetxController {
  // Instantiate the repository directly in the controller
  late final AccountsRepository repository;

  // Dependency injection or initialization within the controller itself
  AccountsController({ApiService? api}) {
    // Use a provided ApiService or create a new one if null
    repository = AccountsRepository(api: api ?? ApiService());
  }

  var accounts = <AccountModel>[].obs;
  var filteredAccounts = <AccountModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  Future<void> fetchAccounts({String? subheadName, bool silent = false}) async {
    try {
      // Only set loading to true if not in silent mode
      if (!silent) {
        isLoading.value = true;
        errorMessage.value = ''; // Reset error message
      }

      final fetchedAccounts = await repository.getAccounts(subheadName: subheadName);
      final nonDrCrdAccounts = fetchedAccounts.where((account) => account.debit != '0' || account.credit != '0').toList();


      accounts.assignAll(nonDrCrdAccounts);
      filteredAccounts.assignAll(fetchedAccounts);
    } catch (error) {
      // Set error message
      errorMessage.value = error.toString();

      // Show error snackbar only if not in silent mode
      if (!silent) {
        _showErrorSnackbar('Failed to fetch accounts', error.toString());
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  void searchAccounts(String query) {
    if (query.isEmpty) {
      filteredAccounts.assignAll(accounts);
    } else {
      filteredAccounts.value = accounts.where((account) {
        return account.name.toLowerCase().contains(query.toLowerCase()) ||
            account.subHead.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Optional: Method to refresh accounts
  Future<void> refreshAccounts({String? subheadName}) async {
    await fetchAccounts(subheadName: subheadName, silent: true);
  }
}
