// // lib/controllers/auth_controller.dart
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../common/color_extension.dart';
// import '../../../service/api_service.dart';
// import '../../home/home.dart';
//
// class AuthController extends GetxController {
//   final ApiService _apiService = ApiService();
//   var isLoading = false.obs;
//   var obscurePassword = true.obs;
//   var username = ''.obs;
//   var password = ''.obs;
//
//   Future<void> login() async {
//     if (username.isEmpty || password.isEmpty) {
//       Get.snackbar("Error", "Please fill in all required fields", backgroundColor: TColor.third);
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       Map<String, dynamic> body = {
//         "Username": username.value.trim(),
//         "Password": password.value.trim(),
//       };
//
//       final response = await _apiService.post("token", body);
//       print(response['status']);
//       print("aj");
//
//       if (response['status'] == "success") {
//         await _handleLoginSuccess(response);
//       } else {
//         Get.snackbar("Error", response['message'] ?? "Login failed", backgroundColor:  TColor.third);
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString().contains('Exception:')
//           ? e.toString().split('Exception: ')[1]
//           : 'Connection error. Please try again.', backgroundColor:  TColor.third);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _handleLoginSuccess(Map<String, dynamic> response) async {
//     try {
//       final token = response['token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       Get.offAll(() => const Home());
//       Get.snackbar("Success", response['message'], backgroundColor:  TColor.secondary);
//     } catch (e) {
//       Get.snackbar("Error", "Error saving user data: ${e.toString()}", backgroundColor:  TColor.third);
//     }
//   }
// }