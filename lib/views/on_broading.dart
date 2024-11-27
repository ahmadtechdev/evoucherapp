import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:evoucher/common/color_extension.dart';
import 'package:evoucher/views/authentication/signin.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Enhance Airline Systems",
      "subtitle": "Revolutionizing airline operations with modern solutions",
      "animation": "assets/animation/Animation - 1732709233466.json",
      "isLastPage": false
    },

    {
      "title": "Streamlined Integration",
      "subtitle": "Seamless integration for websites, mobile apps, and backend systems",
      "animation": "assets/animation/Animation - 1732711157070.json",
      "isLastPage": false
    },
    {
      "title": "Real-time Updates",
      "subtitle": "Empowering airlines with cutting-edge tracking and communication tools",
      "animation": "assets/animation/Animation - 1732012339792.json",
      "isLastPage": false
    },
    {
      "isLastPage": true
    }

  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        final newPage = _pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    if (_currentPage >= _onboardingData.length - 1) {
      Get.offAll(() => const SignIn());
    } else {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    Get.offAll(() => const SignIn());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg1.png'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button (only show for first 3 pages)
              if (_currentPage < 3)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

              // PageView for content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final pageData = _onboardingData[index];

                    if (pageData["isLastPage"]) {
                      return Center(
                        child: Image.asset(
                          'assets/img/logoX.png',
                          height: screenHeight / 2,
                          width: screenWidth / 1.7,
                          fit: BoxFit.contain,
                        ),
                      );
                    } else {
                      return _OnboardingPage(
                        title: pageData["title"]!,
                        subtitle: pageData["subtitle"]!,
                        animationPath: pageData["animation"]!,
                      );
                    }
                  },
                ),
              ),

              // Bottom container with indicators and button
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_currentPage == 3) ...[
                      // Welcome screen content for last page
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
                      const SizedBox(height: 40),
                    ] else ...[
                      // Dots for first 3 pages
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3, // Only show 3 dots
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? TColor.primary
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Button
                    GestureDetector(
                      onTap: _navigateToNextPage,
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
                              _currentPage >= 3
                                  ? 'Sign in to Your Account!'
                                  : 'Next',
                              style: TextStyle(
                                color: TColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_currentPage >= 3) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.airplane_ticket,
                                color: TColor.white,
                                size: 20,
                              ),
                            ],
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

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String animationPath;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation
          Expanded(
            flex: 3,
            child: Lottie.asset(
              animationPath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: TColor.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),


          const SizedBox(height: 16),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,

              color: TColor.white,
              height: 1.5,
              fontStyle: FontStyle.italic, // Adds a subtle emphasis
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
