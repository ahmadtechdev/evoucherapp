// // not_used_bank_voucher_provider.dart
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';
//
// class BankVoucherNotifier extends StateNotifier<AsyncValue<void>> {
//   final Dio _dio;
//
//   BankVoucherNotifier({Dio? dio})
//       : _dio = dio ?? Dio(),
//         super(const AsyncValue.data(null));
//
//   Future<void> submitVoucher({
//     required String date,
//     required List<Map<String, dynamic>> entries,
//   }) async {
//     try {
//       state = const AsyncValue.loading();
//
//       // Prepare request data
//       final requestData = {
//         'date': date,
//         'entries': entries,
//         'voucher_type': 'bank', // Specify voucher type
//         'status': 'active'
//       };
//
//       // Make API call
//       final response = await _dio.post(
//         '/api/vouchers/bank', // Adjust endpoint as needed
//         data: requestData,
//       );
//
//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception('Failed to save voucher: ${response.statusMessage}');
//       }
//
//       state = const AsyncValue.data(null);
//     } catch (error, stack) {
//       state = AsyncValue.error(error, stack);
//       rethrow;
//     }
//   }
// }
//
// final bankVoucherProvider = StateNotifierProvider<BankVoucherNotifier, AsyncValue<void>>((ref) {
//   return BankVoucherNotifier();
// });
//
//
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../../service/api_service.dart';
// //
// // final bankVoucherProvider = StateNotifierProvider<BankVoucherNotifier, AsyncValue<void>>((ref) {
// //   return BankVoucherNotifier();
// // });
// //
// // class BankVoucherNotifier extends StateNotifier<AsyncValue<void>> {
// //   BankVoucherNotifier() : super(const AsyncValue.data(null));
// //
// //   final _apiService = ApiService();
// //
// //   Future<void> submitVoucher({
// //     required String date,
// //     required List<Map<String, dynamic>> entries,
// //   }) async {
// //     try {
// //       state = const AsyncValue.loading();
// //
// //       // Get token from SharedPreferences
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token') ?? '';
// //
// //       if (token.isEmpty) {
// //         throw Exception('Token is missing');
// //       }
// //
// //       final formattedDate = date.split(' ')[0]; // Extract date part only
// //
// //       // Create request body matching the API spec
// //       final requestBody = {
// //         'token': token, // Token as required
// //         'voucher_date': formattedDate,
// //         'entries': entries.map((entry) {
// //           return {
// //             'account_id': entry['account_id'], // Use account_id instead of account
// //             'description': entry['description'], // Ensure description is included
// //             'debit': entry['debit'],
// //             'credit': entry['credit'],
// //             'cheque_no': entry['cheque_no'] ?? null, // Include cheque_no if present
// //           };
// //         }).toList(),
// //       };
// //
// //       // Send the POST request
// //       final response = await _apiService.post('bank-voucher', requestBody);
// //
// //       if (response['status'] == 'success') {
// //         state = const AsyncValue.data(null);
// //         return;
// //       } else {
// //         throw Exception(response['message'] ?? 'Failed to save voucher');
// //       }
// //     } catch (e) {
// //       state = AsyncValue.error(e, StackTrace.current);
// //       rethrow;
// //     }
// //   }
// // }