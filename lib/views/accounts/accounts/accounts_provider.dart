import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../service/api_service.dart';
import 'accounts_modal_class.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final accountsProvider = Provider((ref) => AccountsRepository(
  api: ref.watch(apiServiceProvider),
));

final accountsDataProvider = FutureProvider<List<AccountModel>>((ref) async {
  return ref.watch(accountsProvider).getAccounts();
});

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
