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

      final response = await _apiService.postRequest(
        endpoint: 'homeDashboardsales',
        body: {
          "date": date.toString().split(' ')[0], // Format: YYYY-MM-DD
        },
      );

      dashboardData.value = DashboardData.fromJson(response);
    } on NetworkException catch (e) {
      error.value = e.toString();
      print('Network error: ${e.message}');
    } on UnauthorizedException catch (e) {
      error.value = e.toString();
      print('Authorization error: ${e.message}');
    } on BadRequestException catch (e) {
      error.value = e.toString();
      print('Bad request error: ${e.message}');
    } on ServerException catch (e) {
      error.value = e.toString();
      print('Server error: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      print('Unexpected error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}