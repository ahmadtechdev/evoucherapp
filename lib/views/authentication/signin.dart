import 'package:evoucher/views/authentication/signup.dart';
import 'package:evoucher/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
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
          ).show();
          Get.offAll(() => const Home());
        }
      } else {
        CustomSnackBar(
          message: response['message'],
          backgroundColor: Colors.red,
        ).show();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar(
          message: "Error saving user data: ${e.toString()}",
          backgroundColor: Colors.red,
        ).show();
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      CustomSnackBar(
        message: "Please fill in all required fields",
        backgroundColor: Colors.red,
      ).show();
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
        ).show();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar(
          message: e.toString().contains('Exception:')
              ? e.toString().split('Exception: ')[1]
              : 'Connection error. Please try again.',
          backgroundColor: Colors.red,
        ).show();
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
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1976D2),
                  Color(0xFF2196F3),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: 3.14159, // Equivalent to 180 degrees in radians
              child: CustomPaint(
                size: Size(screenWidth, 100),
                painter: WavesPainter(),
              ),
            ),
          ),



          // Main Content - Centered
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    width: screenWidth * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                              ),
                              TextSpan(
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
                          "Sign In to your Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),

                        RoundTextfield(
                          hintText: "User name",
                          controller: txtUser,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),

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
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpView());
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: TColor.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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

          // Waves at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(screenWidth, 100),
              painter: WavesPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    // Create smooth wave pattern
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.5 + math.sin(i * 0.02) * 20 + math.cos(i * 0.015) * 15,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);

    // Second wave with different opacity
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height * 0.6 + math.cos(i * 0.02) * 15 + math.sin(i * 0.015) * 10,
      );
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}