// controllers/dashboard_controller.dart
import 'package:get/get.dart';

import '../../../../service/api_service.dart';
import '../models/dash_board_modal.dart';


class DashboardController extends GetxController {
  final ApiService _apiService = ApiService();
  final Rx<DashboardData> dashboardData = DashboardData.empty().obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchDashboardData(DateTime date) async {
    try {
      isLoading.value = true;
      error.value = '';

      final queryParams = {
        'date': date.toString().split(' ')[0], // Format: YYYY-MM-DD
      };

      final response = await _apiService.get('home-dashboard', queryParams: queryParams);
      dashboardData.value = DashboardData.fromJson(response);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}