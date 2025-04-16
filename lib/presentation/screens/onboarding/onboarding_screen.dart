import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/core/constants/app_routes.dart';
import 'package:zaindev_application/core/routing/router_utils.dart';

import '../../../core/constants/app_colors.dart';
import 'onboarding_provider.dart';
import 'widgets/onboarding_indicator.dart';
import 'widgets/onboarding_page_widget.dart';
// Import SharedPreferences later
// import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(onboardingPageIndexProvider.notifier).state = index;
  }

  Future<void> _completeOnboarding() async {
    navigateNamed(context, AppRoutes.authWrapper);
  }

  void _nextPage() {
    final currentPage = ref.read(onboardingPageIndexProvider);
    final itemCount = ref.read(onboardingItemsProvider).length;
    if (currentPage < itemCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingItems = ref.watch(onboardingItemsProvider);
    final currentPageIndex = ref.watch(onboardingPageIndexProvider);
    final isLastPage = currentPageIndex == onboardingItems.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingItems.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(item: onboardingItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  OnboardingIndicator(
                    itemCount: onboardingItems.length,
                    currentIndex: currentPageIndex,
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      Opacity(
                        opacity: isLastPage ? 0.0 : 1.0, // Hide on last page
                        child: TextButton(
                          onPressed: isLastPage ? null : _completeOnboarding,
                          child: const Text('تخطي'), // "Skip"
                        ),
                      ),

                      // Next / Get Started Button
                      ElevatedButton(
                        onPressed: isLastPage ? _completeOnboarding : _nextPage,
                        style: ElevatedButton.styleFrom(
                          // Use accent color for the final button? Optional.
                          backgroundColor: isLastPage ? AppColors.accent : AppColors.primary,
                          foregroundColor: isLastPage ? AppColors.textOnAccent : AppColors.textOnPrimary,
                        ),
                        child: Text(isLastPage ? 'ابدأ الآن' : 'التالي'), // "Get Started" : "Next"
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}