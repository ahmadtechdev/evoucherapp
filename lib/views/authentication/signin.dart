import 'package:evoucher/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/snackbar.dart';
import '../../service/api_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    txtUser.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> _handleLoginSuccess(Map<String, dynamic> response) async {
    try {
      if (response['status'] == "success") {
        final token = response['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        if (mounted) {
          CustomSnackBar(
            message: response['message'],
            backgroundColor: Colors.green,
          ).show(context);
          Get.offAll(() => const Home());
        }
      } else {
        CustomSnackBar(
          message: response['message'],
          backgroundColor: Colors.red,
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar(
          message: "Error saving user data: ${e.toString()}",
          backgroundColor: Colors.red,
        ).show(context);
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      const CustomSnackBar(
        message: "Please fill in all required fields",
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> body = {
        "user_name": txtUser.text.trim(),
        "password": txtPassword.text.trim(),
      };

      final response = await _apiService.post("login", body);

      if (!mounted) return;

      if (response['status'] == "success") {
        await _handleLoginSuccess(response);
      } else {
        CustomSnackBar(
          message: response['message'] ?? "Login failed",
          backgroundColor: Colors.red,
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar(
          message: e.toString().contains('Exception:')
              ? e.toString().split('Exception: ')[1]
              : 'Connection error. Please try again.',
          backgroundColor: Colors.red,
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Login Form
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Image.asset(
                              'assets/img/newLogo.png',

                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            // Let's Travel Text
                            RichText(
                              text:  TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Travel ",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),TextSpan(
                                    text: "Agency ",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Accounting",
                                    style: TextStyle(
                                      color: TColor.secondary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Software.",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                             Text(
                              "Discover the World with Every Sign In",
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 40),

                            RoundTextfield(
                              hintText: "User name",
                              controller: txtUser,
                            ),
                            const SizedBox(height: 25),
                            RoundTextfield(
                              hintText: "Password",
                              controller: txtPassword,
                              obscureText: _obscurePassword,

                              right: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: TColor.secondaryText,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.offAll(() => const Home());
                                },
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: isLoading
                                  ? Center(
                                child: CircularProgressIndicator(
                                  color: TColor.primary,
                                ),
                              )
                                  : RoundButton(
                                title: "Login",
                                onPressed: _handleLogin,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}