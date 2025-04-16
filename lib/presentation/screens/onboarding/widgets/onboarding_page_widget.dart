import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'onboarding_item.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain, // Adjust fit as needed
               errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported_outlined, size: size.width * 0.5, color: AppColors.disabled,
               ),
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                 Text(
                  item.title,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  item.description,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5, // Line height for readability
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}