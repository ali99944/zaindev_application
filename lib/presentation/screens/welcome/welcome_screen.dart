import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/core/constants/app_routes.dart';
import 'package:zaindev_application/core/routing/router_utils.dart';
import 'package:zaindev_application/presentation/extensions/sizedbox.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Section (Logo and Welcome Text)
              Column(
                children: [
                  SizedBox(height: size.height * 0.1), // Space from top
                  Image.asset(
                    AppAssets.logo,
                    height: 80, // Adjust size
                     errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.business_sharp, size: 80, color: AppColors.primary,
                     ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'أهلاً بك في زين التنموية', // "Welcome to Zain Development"
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12.0),
                   Text(
                    'منصتك المتكاملة لإدارة المشاريع والخدمات.', // "Your integrated platform for managing projects and services."
                    style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
  24.h,
              // Bottom Section (Buttons)
              Column(
                 children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                    onPressed: () {
                      navigateNamed(context, AppRoutes.login);
                    },
                    child: const Text('تسجيل الدخول'), // "Login / Create Account"
                  ),
                  8.w,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    onPressed: () {
                      navigateNamed(context, AppRoutes.register);
                    },
                    child: const Text('إنشاء حساب', style: TextStyle(color: Colors.black)), // "Login / Create Account"
                  ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                   TextButton(
                    onPressed: () {
                      navigateNamed(context, AppRoutes.homeNavigator);
                    },
                    child: const Text('المتابعة كزائر'), // "Continue as Guest"
                  ),
                 ],
               ),
            ],
          ),
        ),
      ),
    );
  }
}