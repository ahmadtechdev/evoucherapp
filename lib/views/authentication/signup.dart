import 'package:evoucher/views/authentication/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/snackbar.dart';
import '../../service/api_service.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

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

  final ApiService _apiService = ApiService();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 64),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                      RoundTextfield(
                        hintText: "Full Name",
                        controller: txtName,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "Valid Email",
                        controller: txtEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "Contact No",
                        controller: txtMobile,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "Company Name",
                        controller: txtName,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "Company Address",
                        controller: txtAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "City Name",
                        controller: txtAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundTextfield(
                        hintText: "Select Demo",
                        controller: txtAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundButton(
                          title: "Sign Up",
                          onPressed: () {
                            // btnSignUp();
                          }),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const SignIn());
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
                ),
              ],
            ),
          ),
        ),
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
