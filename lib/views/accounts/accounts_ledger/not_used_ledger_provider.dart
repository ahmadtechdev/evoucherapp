// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
//
// import '../../../service/api_service.dart';
// import '../accounts/not_used_accounts_provider.dart';
// import 'ledger_modal.dart';
//
// final ledgerProvider = Provider((ref) => LedgerRepository(
//   api: ref.watch(apiServiceProvider),
// ));
//
// final ledgerDataProvider = FutureProvider.family<(LedgerMasterData, List<LedgerVoucher>), ({String accountId, DateTime fromDate, DateTime toDate})>((ref, params) async {
//   return ref.watch(ledgerProvider).getLedger(
//     accountId: params.accountId,
//     fromDate: params.fromDate,
//     toDate: params.toDate,
//   );
// });
//
// class LedgerRepository {
//   final ApiService api;
//
//   LedgerRepository({required this.api});
//
//   Future<(LedgerMasterData, List<LedgerVoucher>)> getLedger({
//     required String accountId,
//     required DateTime fromDate,
//     required DateTime toDate,
//   }) async {
//     final response = await api.get(
//       'account-ledger',
//       queryParams: {
//         'account_id': accountId,
//         'from_date': DateFormat('yyyy-MM-dd').format(fromDate),
//         'to_date': DateFormat('yyyy-MM-dd').format(toDate),
//       },
//     );
//
//     if (response['status'] == 'success') {
//       final masterData = LedgerMasterData.fromJson(response['master_data']);
//       final vouchers = (response['vouchers'] as List)
//           .map((json) => LedgerVoucher.fromJson(json))
//           .toList();
//       return (masterData, vouchers);
//     }
//
//     throw Exception('Failed to fetch ledger data');
//   }
// }
