import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api_service.dart';
import 'accounts_modal_class.dart';

class AccountsRepository {
  final ApiService api;

  AccountsRepository({required this.api});

  Future<List<AccountModel>> getAccounts({String? subheadName}) async {
    final Map<String, String> queryParams = {};
    if (subheadName != null) {
      queryParams['subhead_name'] = subheadName;
    }

    final response = await api.get('fetch-accounts', queryParams: queryParams);

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

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  Future<void> fetchAccounts({String? subheadName}) async {
    try {
      isLoading.value = true;
      final fetchedAccounts = await repository.getAccounts(subheadName: subheadName);
      accounts.assignAll(fetchedAccounts);
      filteredAccounts.assignAll(fetchedAccounts);
    } catch (error) {
      _showErrorSnackbar('Failed to fetch accounts', error.toString());
    } finally {
      isLoading.value = false;
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
    );
  }
}
