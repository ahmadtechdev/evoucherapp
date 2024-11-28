import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/views/authentication/signin.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/img/newLogo.png',
            scale: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/img/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // Logo section
              Expanded(
                flex: 2,
                child: Center(
                  child:Container(



                    // child: Image.asset(
                    //   'assets/img/logoX.png',
                    //   height: screenHeight / 2,
                    //   width: screenWidth/1.7,
                    //   fit: BoxFit.contain,
                    // ),
                  ) ,
                ),
              ),

              // White container at bottom
              Container(
                width: double.infinity,
                height: 240,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: " Best Travel ",
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
                            text: " Software In Pakistan.",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignIn());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in to Your Account!',
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.airplane_ticket,
                              color: TColor.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}