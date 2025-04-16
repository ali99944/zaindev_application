import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../screens/auth/auth_providers.dart';
import '../screens/settings/settings_screen.dart'; // Import providers


final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  // Simulate a delay for fetching onboarding status
  await Future.delayed(const Duration(seconds: 1));
  return true; // Default to false for now
});


class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both providers. They might be in loading/error states initially.
    final onboardingStatusAsync = ref.watch(onboardingCompletedProvider);
    final authIsLoggedIn = ref.watch(authStateProvider); // Assuming this returns bool directly for now

    return Scaffold(
      body: onboardingStatusAsync.when(
        data: (isOnboardingCompleted) {
          // Use WidgetsBinding to schedule navigation after the build is complete.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Ensure the widget is still mounted before navigating
            if (!context.mounted) return;

            if (!isOnboardingCompleted) {
              print("AuthWrapper: Navigating to Onboarding");
              Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
            } else {
              // Onboarding is done, check login status
              if (authIsLoggedIn) {
                print("AuthWrapper: Navigating to Home Navigator");
                Navigator.pushReplacementNamed(context, AppRoutes.homeNavigator);
              } else {
                 print("AuthWrapper: Navigating to Welcome");
                // Onboarding done, but not logged in -> Show Welcome (Login/Guest options)
                Navigator.pushReplacementNamed(context, AppRoutes.welcome);
              }
            }
          });

          // Return a loading indicator while the navigation is being scheduled/executed.
          // This prevents showing a blank screen briefly.
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        },
        loading: () {
           print("AuthWrapper: Loading onboarding status...");
          // Show loading indicator while checking onboarding status
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        },
        error: (error, stackTrace) {
           print("AuthWrapper: Error loading onboarding status: $error");
          // Handle error state, e.g., show an error message and a retry button
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.accent, size: 50),
                const SizedBox(height: 16),
                const Text('حدث خطأ أثناء تحميل الإعدادات.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Invalidate the provider to trigger a reload attempt
                    ref.invalidate(onboardingCompletedProvider);
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}