import 'package:get/get.dart';

class AuthController extends GetxController {
  // Keep only the login type observable
  // ignore: non_constant_identifier_names
  var login_type = "".obs;

  // Method to update login type
  void updateLoginType(String type) {
    login_type.value = type;
  }

// Add any other authentication-related logic here
// For example:
// - Password validation rules
// - User role management
// - Authentication state validation
// - Login/logout business logic
}