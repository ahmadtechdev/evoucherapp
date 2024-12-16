// session_manager.dart

import 'package:evoucher/views/welcome_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this package to pubspec.yaml

class SessionManager extends GetxController {
  static const String TOKEN_KEY = 'token';
  static const String TOKEN_EXPIRY_KEY = 'token_expiry';

  final _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  // Initialize session on app start
  Future<void> initializeSession() async {
    final token = await getToken();
    if (token != null) {
      if (await isTokenValid()) {
        _isLoggedIn.value = true;
        startTokenExpiryTimer();
      } else {
        await logout();
      }
    }
  }

  // Save token with expiry
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);

    // Calculate and save expiry time (current time + 3 hours)
    final expiryTime = DateTime.now().add(const Duration(hours: 3)).millisecondsSinceEpoch;
    await prefs.setInt(TOKEN_EXPIRY_KEY, expiryTime);

    _isLoggedIn.value = true;
    startTokenExpiryTimer();
  }

  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  // Check if token is valid
  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(TOKEN_EXPIRY_KEY);

    if (expiryTime == null) return false;

    return DateTime.now().millisecondsSinceEpoch < expiryTime;
  }

  // Start timer to check token expiry
  void startTokenExpiryTimer() {
    Future.delayed(const Duration(minutes: 5), () async {
      if (!await isTokenValid()) {
        await logout();
      } else {
        startTokenExpiryTimer(); // Continue checking
      }
    });
  }

  // Logout function
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove(TOKEN_EXPIRY_KEY);
    _isLoggedIn.value = false;
    Get.offAll(()=>const WelcomeScreen()); // Navigate to sign in screen
  }
}