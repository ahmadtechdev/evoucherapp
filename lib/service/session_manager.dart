// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/welcome_view.dart';

class SessionManager extends GetxController {
  static const String TOKEN_KEY = 'token';
  static const String TOKEN_EXPIRY_KEY = 'token_expiry';
  static const String CLIENT_TYPE_KEY = 'client_type';
  static const String LOGIN_TYPE_KEY = 'login_type';
  static const String BASE_URL_KEY = 'base_url';

  final _isLoggedIn = false.obs;
  final baseUrl = "https://evoucher.pk/api-new/".obs;

  bool get isLoggedIn => _isLoggedIn.value;

  // Method to update base URL based on client type
  void updateBaseUrl(String client) {
    String newUrl = switch (client) {
      'TOC' => "https://evoucher.pk/api-toc-test/",
      _ => "https://evoucher.pk/api-new/",
    };
    baseUrl.value = newUrl;
    _saveBaseUrl(newUrl);
  }

  Future<void> _saveBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(BASE_URL_KEY, url);
  }

  Future<void> initializeSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await getToken();
    final savedBaseUrl = prefs.getString(BASE_URL_KEY);

    if (savedBaseUrl != null) {
      baseUrl.value = savedBaseUrl;
    }

    if (token != null) {
      if (await isTokenValid()) {
        _isLoggedIn.value = true;
        final clientType = await getClientType();
        if (clientType != null) {
          updateBaseUrl(clientType);
        }
        startTokenExpiryTimer();
      } else {
        await logout();
      }
    }
  }

  Future<void> saveToken(
      String token, String clientType, String loginType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
    await prefs.setString(CLIENT_TYPE_KEY, clientType);
    await prefs.setString(LOGIN_TYPE_KEY, loginType);
    updateBaseUrl(clientType);

    final expiryTime =
        DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;
    await prefs.setInt(TOKEN_EXPIRY_KEY, expiryTime);

    _isLoggedIn.value = true;
    startTokenExpiryTimer();
  }

  // Existing methods remain the same
  Future<String?> getClientType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(CLIENT_TYPE_KEY);
  }

  Future<String?> getLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(LOGIN_TYPE_KEY);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(TOKEN_EXPIRY_KEY);
    if (expiryTime == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expiryTime;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove(TOKEN_EXPIRY_KEY);
    await prefs.remove(CLIENT_TYPE_KEY);
    await prefs.remove(LOGIN_TYPE_KEY);
    await prefs.remove(BASE_URL_KEY);
    baseUrl.value = "https://evoucher.pk/api-new/";
    _isLoggedIn.value = false;
    Get.offAll(() => const WelcomeScreen());
  }

  void startTokenExpiryTimer() {
    Future.delayed(const Duration(minutes: 5), () async {
      if (!await isTokenValid()) {
        await logout();
      } else {
        startTokenExpiryTimer();
      }
    });
  }
}
