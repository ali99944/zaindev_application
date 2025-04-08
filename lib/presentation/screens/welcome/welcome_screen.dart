import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/presentation/screens/home/home_screen.dart';

import '../../../core/constants/app_colors.dart';

class WelcomeScreen extends ConsumerWidget {
  static const String route = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by notches/status bars
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
            children: [
              // Logo or Illustration Section
              const Spacer(), // Pushes content towards center/bottom
              Image(
                image: const AssetImage('assets/images/zain_logo.png'),
                height: size.height * 0.15, // Responsive height
              ),
              const SizedBox(height: 30),

              // Welcome Text Section
              Text(
                'مرحباً بك في زين التنموية', // Replace with localization later
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'منصتك المتكاملة لجميع خدمات ومشاريع المؤسسة ومنتجاتها.', // Replace with localization later
                style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const Spacer(), // Pushes buttons towards the bottom

              // Action Buttons Section
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login/Signup Screen
                   Navigator.pushNamed(context, '/login'); // TODO: Create Login Screen
                   print("Navigate to Login/Signup");
                },
                child: const Text('تسجيل الدخول / إنشاء حساب'), // Replace with localization
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  // Navigate to Home Screen as Guest
                   Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (route) => false); // TODO: Create Home Screen
                   print("Continue as Guest");
                },
                child: const Text('المتابعة كزائر'), // Replace with localization
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}