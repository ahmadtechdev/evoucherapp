// controllers/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dash_board_modal.dart';

class DashboardController extends GetxController {
  final String baseUrl = 'https://evoucher.pk/api-new/';
  final Rx<DashboardData> dashboardData = DashboardData.empty().obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchDashboardData(DateTime date) async {
    try {
      isLoading.value = true;
      error.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.Request('POST',
          Uri.parse('${baseUrl}homeDashboardsales'));

      request.body = json.encode({
        "date": date.toString().split(' ')[0], // Format: YYYY-MM-DD
      });

      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        dashboardData.value = DashboardData.fromJson(responseData);
      } else {
        throw Exception(response.reasonPhrase ?? 'Request failed');
      }
    } catch (e) {
      error.value = e.toString();
      print('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}