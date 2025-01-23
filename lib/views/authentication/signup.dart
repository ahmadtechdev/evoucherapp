
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_text_field.dart';
import '../../common_widget/snackbar.dart';
import 'signin.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

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



          // Main Content - Centered
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child:
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: screenWidth * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 30,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          "Add your details to Register",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Full Name",
                          controller: txtName,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Valid Email",
                          controller: txtEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Contact No",
                          controller: txtMobile,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Company Name",
                          controller: txtName,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Company Address",
                          controller: txtAddress,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "City Name",
                          controller: txtAddress,
                        ),
                        const SizedBox(height: 16),
                        RoundTextField(
                          hintText: "Select Demo",
                          controller: txtAddress,
                        ),
                        const SizedBox(height: 16),
                        RoundButton(
                            title: "Sign Up",
                            onPressed: () {
                              CustomSnackBar(message: "Sign-up is currently unavailable on mobile. ", backgroundColor: TColor.fourth).show();

                            }),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignIn(), transition: Transition.fadeIn);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Already have an Account? ",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: TColor.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  ,
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

  // void btnSignUp() async {
  //   if (txtPassword.text != txtConfirmPassword.text) {
  //     CustomSnackBar(
  //       message: "Passwords do not match",
  //       backgroundColor: Colors.red,
  //     ).show(context);
  //     return;
  //   }
  //
  //   try {
  //     Map<String, dynamic> body = {
  //       "name": txtName.text,
  //       "email": txtEmail.text,
  //       "phone": txtMobile.text,
  //       "password": txtPassword.text,
  //       "password_confirmation": txtPassword.text,
  //     };
  //
  //     final response = await _apiService.post("register", body);
  //
  //     if (response['success'] == "true") {
  //       CustomSnackBar(
  //         message: response['message'],
  //         backgroundColor: Colors.green,
  //       ).show(context);
  //       Get.to(() => LoginView());
  //     } else {
  //       String errorMessage = response['message'];
  //       if (response['errors'] != null) {
  //         Map<String, dynamic> errors = response['errors'];
  //         errors.forEach((key, value) {
  //           if (value is List && value.isNotEmpty) {
  //             errorMessage += "\n${value.first}";
  //           }
  //         });
  //       }
  //       CustomSnackBar(
  //         message: errorMessage,
  //         backgroundColor: Colors.red,
  //       ).show(context);
  //     }
  //   } catch (e) {
  //     CustomSnackBar(
  //       message: 'Error: $e',
  //       backgroundColor: Colors.red,
  //     ).show(context);
  //   }
  // }
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

