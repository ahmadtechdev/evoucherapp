import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service/api_service.dart';

final bankVoucherProvider = StateNotifierProvider<BankVoucherNotifier, AsyncValue<void>>((ref) {
  return BankVoucherNotifier();
});

class BankVoucherNotifier extends StateNotifier<AsyncValue<void>> {
  BankVoucherNotifier() : super(const AsyncValue.data(null));

  final _apiService = ApiService();

  Future<void> submitVoucher({
    required String date,
    required List<Map<String, dynamic>> entries,
  }) async {
    try {
      state = const AsyncValue.loading();

      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token is missing');
      }

      final formattedDate = date.split(' ')[0]; // Extract date part only

      // Create request body matching the API spec
      final requestBody = {
        'token': token, // Token as required
        'voucher_date': formattedDate,
        'entries': entries.map((entry) {
          return {
            'account_id': entry['account_id'], // Use account_id instead of account
            'description': entry['description'], // Ensure description is included
            'debit': entry['debit'],
            'credit': entry['credit'],
            'cheque_no': entry['cheque_no'] ?? null, // Include cheque_no if present
          };
        }).toList(),
      };

      // Send the POST request
      final response = await _apiService.post('bank-voucher', requestBody);

      if (response['status'] == 'success') {
        state = const AsyncValue.data(null);
        return;
      } else {
        throw Exception(response['message'] ?? 'Failed to save voucher');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}