import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: currentIndex == index ? 24.0 : 8.0, // Active dot is wider
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.primary : AppColors.disabled.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4.0), // Low radius
          ),
        );
      }),
    );
  }
}