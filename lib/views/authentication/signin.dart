import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_dropdown_field.dart';
import '../../common_widget/round_text_field.dart';
import '../../common_widget/snackbar.dart';
import '../../service/api_service.dart';
import '../../service/session_manager.dart';
import '../home/home.dart';
import 'signup.dart';

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



  String? selectedClient;
  final List<String> clients = [
    'Travel 1',
    'Travel 2',
    'Travel 3',
    'Travel 4',
    'Travel 5',
    'TOC'
  ];

  @override
  void dispose() {
    txtUser.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  final SessionManager _sessionManager = Get.find<SessionManager>();

  // Function to get travel value based on selected client
  String getTravelValue(String? client) {
    if (client == null) return "1"; // Default value

    switch (client) {
      case 'Travel 1':
        return "1";
      case 'Travel 2':
        return "2";
      case 'Travel 3':
        return "3";
      case 'Travel 4':
        return "4";
      case 'Travel 5':
        return "5";
      case 'TOC':
        return "0";
      default:
        return "1"; // Default fallback
    }
  }

  Future<void> _handleLogin() async {
    // First validate the form
    if (!_formKey.currentState!.validate()) {
      CustomSnackBar(
        message: "Please fill in all required fields",
        backgroundColor: Colors.red,
      ).show();
      return;
    }

    // Additional validation for empty fields
    if (txtUser.text.trim().isEmpty ||
        txtPassword.text.trim().isEmpty ||
        selectedClient == null) {
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
        "Username": txtUser.text.trim(),
        "Password": txtPassword.text.trim(),
        "Plateform": "App",
        "travel": getTravelValue(selectedClient),
      };

      final response =
          await _apiService.postRequest(endpoint: "token", body: body);

      print("response data");
      print(response);
      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      if (response.containsKey("token")) {
        final token = response['token'];
        final access = response['access'] as Map<String, dynamic>?; // Get access data



        await _sessionManager.saveToken(
            token,
            selectedClient!,
            response['login_type'] ?? "travel",
            access // Pass access data to session manager
        );

        if (mounted) {
          CustomSnackBar(
            message: "Login Successfully",
            backgroundColor: TColor.secondary,
          ).show();
          Get.offAll(() => const Home());
        }
      } else {
        // Show error message without navigation
        if (mounted) {
          CustomSnackBar(
            message: response['Error'] ?? "Invalid credentials",
            backgroundColor: TColor.third,
          ).show();
          return;
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar(
          message: e.toString(),
          backgroundColor: TColor.third,
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

          // Main Content - Centered
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                        const SizedBox(height: 12),
                        // Let's Travel Text
                        RichText(
                          text: TextSpan(
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
                        const SizedBox(height: 12),

                        // Dropdown for client selection
                        RoundDropdownField(
                          hintText: "Select Client",
                          value: selectedClient,
                          items: clients,
                          onChanged: (String? value) {
                            setState(() {
                              selectedClient = value;
                              if (value != null) {
                                _sessionManager.updateBaseUrl(value);
                                print(
                                    "Selected client: $value, Travel value: ${getTravelValue(value)}");
                              }
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a client" : null,
                          right: Icon(
                            Icons.arrow_drop_down,
                            color: TColor.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 12),

                        RoundTextField(
                          hintText: "User name",
                          controller: txtUser,
                        ),
                        const SizedBox(height: 12),
                        RoundTextField(
                          hintText: "Password",
                          controller: txtPassword,
                          obscureText: _obscurePassword,
                          right: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColor.secondaryText,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

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
