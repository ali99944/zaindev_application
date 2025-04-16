import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // TODO: Check if onboarding is completed using SharedPreferences
    bool onboardingCompleted = false; // Placeholder

    if (!mounted) return;

    // Use Navigator for navigation
    if (onboardingCompleted) {
      // TODO: Check login status
      bool isLoggedIn = false; // Placeholder
      if (isLoggedIn) {
        // Navigate to home and remove splash screen from stack
        Navigator.pushReplacementNamed(context, AppRoutes.home); // Assuming home route exists
      } else {
        // Navigate to welcome and remove splash screen from stack
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    } else {
      // Navigate to onboarding and remove splash screen from stack
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          AppAssets.logo,
          width: 150,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.business_outlined, size: 100, color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}