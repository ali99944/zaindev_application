import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/welcome/welcome_screen.dart';

import '../../../core/constants/app_colors.dart';

// Data structure for onboarding content
class OnboardingPageData {
  final String imagePathOrIcon; // Use IconData for now, replace with asset paths
  final String title;
  final String description;
  final bool isIcon; // Flag to differentiate between IconData and image path

  OnboardingPageData({
    required this.imagePathOrIcon,
    required this.title,
    required this.description,
    this.isIcon = false, // Default to assuming it's an asset path
  });
}

// --- Define Onboarding Content (Tailored to ZainDev) ---
final List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    imagePathOrIcon: 'assets/images/onboarding_1.png', // Replace with actual asset
    // imagePathOrIcon: Icons.phone_android_outlined, isIcon: true, // Placeholder Icon
    title: "زين التنموية في جيبك",
    description: "جميع خدمات ومشاريع ومنتجات المؤسسة متاحة الآن بسهولة عبر التطبيق.",
  ),
  OnboardingPageData(
    imagePathOrIcon: 'assets/images/onboarding_2.png', // Replace with actual asset
    // imagePathOrIcon: Icons.ac_unit_outlined, isIcon: true, // Placeholder Icon
    title: "خدمات تكييف متكاملة",
    description: "اطلب تركيب، صيانة، أو استشارة فنية لمكيفات الهواء بخطوات بسيطة.",
  ),
  OnboardingPageData(
    imagePathOrIcon: 'assets/images/onboarding_3.png', // Replace with actual asset
    // imagePathOrIcon: Icons.shopping_cart_checkout_outlined, isIcon: true, // Placeholder Icon
    title: "تسوّق وتتبّع بسهولة",
    description: "استعرض أحدث المنتجات والعروض وتتبع حالة طلباتك أولاً بأول.",
  ),
];
// --- End Onboarding Content ---


class OnboardingScreen extends ConsumerStatefulWidget {
  static const String route = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToWelcome() {
    // Navigate to Welcome screen and remove onboarding from stack
    Navigator.pushReplacementNamed(context, WelcomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background, // Or specific onboarding background color if desired
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for sliding content
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingPages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _buildPageContent(
                  context: context,
                  pageData: onboardingPages[index],
                  size: size,
                  textTheme: textTheme,
                );
              },
            ),

            // Skip Button (Top Right)
            Positioned(
              top: 10,
              right: 20,
              child: TextButton(
                onPressed: _navigateToWelcome,
                child: Text(
                  'تخطّي', // Skip
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                ),
              ),
            ),

            // Bottom Section (Indicator and Button)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                      (index) => _buildPageIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Action Button
                  _buildActionButton(context, textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the content of a single onboarding page
  Widget _buildPageContent({
    required BuildContext context,
    required OnboardingPageData pageData,
    required Size size,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          // Illustration/Icon Area
          SizedBox(
            height: size.height * 0.35, // Adjust height as needed
            child: pageData.isIcon
                ? Icon(pageData.imagePathOrIcon as IconData, size: 150, color: AppColors.primary) // Placeholder Icon
                : Image.asset(pageData.imagePathOrIcon, fit: BoxFit.contain), // Placeholder Image
          ),
          const SizedBox(height: 40),

          // Text Content
          Text(
            pageData.title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            pageData.description,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80), // Space before indicator/button area
        ],
      ),
    );
  }

  // Builds the page indicator dots
  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0, // Active dot is wider
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.0), // Low radius
      ),
    );
  }

  // Builds the bottom action button (Continue / Get Started)
  Widget _buildActionButton(BuildContext context, TextTheme textTheme) {
    bool isLastPage = _currentPage == onboardingPages.length - 1;
    return SizedBox(
      width: double.infinity, // Make button fill width
      child: ElevatedButton(
        // Style follows theme: amber background, black text, low radius, no shadow
        onPressed: () {
          if (isLastPage) {
            _navigateToWelcome();
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Text(isLastPage ? 'ابدأ الآن' : 'متابعة'), // Get Started / Continue
      ),
    );
  }
}